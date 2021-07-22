//
//		File Name:		GLTriangle3DController.m
//		Product Name:	MyProject
//		Author:			anker@Tmac
//		Created Date:	2021/5/26 10:17 AM
//		
// * Copyright © 2021 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
//		All rights reserved.
//'--------------------------------------------------------------------'
	

#import "GLTriangle3DController.h"

#import "ShaderOperations.h"
#import <GLKit/GLKit.h>

const GLfloat vPyramid[18*3] = {
    1.0, -0.8, 0.0,
    0.0, -0.8, -1.0,
    0.0, 0.8, 0.0,

    0.0, -0.8, 1.0,
    1.0, -0.8, 0.0,
    0.0f, 0.8f, 0.0f,

    -1.0, -0.8, 0.0,
    0.0, -0.8, 1.0,
    0.0, 0.8, 0.0,

    0.0, -0.8, -1.0,
    -1.0, -0.8, 0.0,
    0.0, 0.8, 0.0,

    0.0, -0.8, 1.0,
    -1.0, -0.8, 0.0,
    0.0, -0.8, -1.0,

    1.0, -0.8, 0.0,
    0.0, -0.8, 1.0,
    0.0, -0.8, -1.0,
};

@interface GLTriangle3DController ()
{
    EAGLContext *_eaglContext; // OpenGL context,管理使用opengl es进行绘制的状态,命令及资源
    CAEAGLLayer *_eaglLayer;
    
    GLuint _colorRenderBuffer; // 渲染缓冲区
    GLuint _frameBuffer; // 帧缓冲区
    //3D 深度缓冲区
    GLuint _depthBuffer; //深度缓冲区
    
    GLuint _glProgram;
    GLuint _positionSlot; // 用于绑定shader中的Position参数
    GLuint _colorSlot;      // 用于绑定shader中的SourceColor参数
    GLint _renderbufferWidth, _renderbufferHeight;
}
//3D 矩阵
@property (assign, nonatomic) GLint projectionLoc, modelViewLoc;
@property (strong, nonatomic) CADisplayLink *displayLink;       //让图形定时转动
@property (nonatomic) GLKVector3 modelRotate;
@end

@implementation GLTriangle3DController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavWithTitle:@"Triangle" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    
    [self createView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    if(parent==nil){
        [self tearDownOpenGLBuffers];
        self.displayLink.paused = YES;
        [self.displayLink invalidate];
//        [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop]
//                                    forMode:NSDefaultRunLoopMode];
    }
}

- (void)createDisplayLink{
    self.modelRotate = GLKVector3Make(0.0f, 0.0f, 0.0f);
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(displayContents:)];
    
    self.displayLink.preferredFramesPerSecond = 25;
    
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
    
}

- (void)createView
{
    [self createDisplayLink];
    //初始化一些环境和参数
    //上下文
    [self setupOpenGLContext];
    [self setupCAEAGLLayer];
    [self tearDownOpenGLBuffers];
    //渲染的buffer
    [self setupOpenGLBuffers];
    
    //编译shaders
    [self processShaders];
    
    [self updateMat];
}

- (void)setupOpenGLContext {
    //setup context, 渲染上下文，管理所有绘制的状态，命令及资源信息。
    _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; //opengl es 2.0
    [EAGLContext setCurrentContext:_eaglContext]; //设置为当前上下文。
}
- (void)setupCAEAGLLayer {

    _eaglLayer = [CAEAGLLayer layer];
//    _eaglLayer.frame = self.view.frame;
    _eaglLayer.frame = CGRectMake(0, NavigationBar_HEIGHT, self.view.frame.size.width, SCREEN_HEIGHT-NavigationBar_HEIGHT);
    _eaglLayer.opaque = YES; //CALayer默认是透明的
    _eaglLayer.contentsScale = [UIScreen mainScreen].scale;

    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
    [self.view.layer addSublayer:_eaglLayer];
}

- (void)updateMat{
    // 设置清屏颜色
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    // 用来指定要用清屏颜色来清除由mask指定的buffer，此处是color buffer
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //3D，加入深度测试
    glEnable(GL_DEPTH_TEST);
    //开启背面剔除
    glEnable(GL_CULL_FACE);
    
    //设置模型矩阵
    GLKMatrix4 modelMat4 = GLKMatrix4Identity;
    //加入位移
    modelMat4 = GLKMatrix4Translate(modelMat4, 0.0, 0.0, -3);
    //加入旋转
    modelMat4 = GLKMatrix4Rotate(modelMat4, self.modelRotate.x, 1, 0, 0);
//    modelMat4 = GLKMatrix4Rotate(modelMat4, self.modelRotate.y, 0, 1, 0);
//    modelMat4 = GLKMatrix4Rotate(modelMat4, self.modelRotate.z, 0, 0, 1);
    [self setModelViewMat4:modelMat4];
    //开始透视投影
    GLfloat projectionScaleFix = _eaglLayer.bounds.size.width / _eaglLayer.bounds.size.height;
    GLKMatrix4 projectionMat4 = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(80),
                                               projectionScaleFix,
                                               1,
                                               180);
    [self setProjectionMat4:projectionMat4];
    
    
    glViewport(0, 0, _renderbufferWidth, _renderbufferHeight);
    
    //进行渲染
    [self render];
    [_eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}

#pragma mark - tearDownOpenGLBuffers

- (void)tearDownOpenGLBuffers {
    //destory render and frame buffer
    if (_colorRenderBuffer) {
        glDeleteRenderbuffers(1, &_colorRenderBuffer);
        _colorRenderBuffer = 0;
    }
    
    if (_frameBuffer) {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    
    if (_depthBuffer) {
        glDeleteRenderbuffers(1, &_depthBuffer);
        _depthBuffer = 0;
    }
}

#pragma mark - setupOpenGLBuffers

- (void)setupOpenGLBuffers {
    
    // FBO用于管理colorRenderBuffer，离屏渲染
    glGenFramebuffers(1, &_frameBuffer);
    //设置为当前framebuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glGenRenderbuffers(1, &_colorRenderBuffer);
    // 设置为当前renderBuffer
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    //为color renderbuffer 分配存储空间
    [_eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_renderbufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_renderbufferHeight);
    
    //3D 深度缓冲区
    glGenRenderbuffers(1, &_depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER,
                          GL_DEPTH_COMPONENT16,
                          _renderbufferWidth,
                          _renderbufferHeight);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBuffer);
}

- (void)processShaders {
    // 编译shaders
    _glProgram = [ShaderOperations compileShaders:@"Triangle3DVertex" shaderFragment:@"Triangle3DFragment"];
    
    glUseProgram(_glProgram);
    // 获取指向vertex shader传入变量的指针, 然后就通过该指针来使用
    // 即将_positionSlot 与 shader中的Position参数绑定起来，作为输入
    _colorSlot = glGetAttribLocation(_glProgram, "SourceColor");
    _positionSlot = glGetAttribLocation(_glProgram, "Position");
    //3D 加入两个转换的3D矩阵
    self.projectionLoc = glGetUniformLocation(_glProgram, "u_Projection");
    self.modelViewLoc  = glGetUniformLocation(_glProgram, "u_ModelView");
}

- (void)setProjectionMat4:(GLKMatrix4)projectMat4 {
    
//    [self setUniformMat4:projectMat4 loc:self.projectionLoc];
    glUniformMatrix4fv(self.projectionLoc, 1, GL_FALSE, projectMat4.m);
    
}

- (void)setModelViewMat4:(GLKMatrix4)modelViewMat4 {
    
    glUniformMatrix4fv(self.modelViewLoc, 1, GL_FALSE, modelViewMat4.m);
    
}

- (void)render
{
    [self renderVertices];
}

- (void)renderVertices {

    // 给_positionSlot传递vertices数据
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vPyramid);
    glEnableVertexAttribArray(_positionSlot);
    
    //颜色全为红色
    glVertexAttrib4f(_colorSlot, 1.0, 0.0, 0.0, 1);
    
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    // Draw triangle
    glDrawArrays(GL_TRIANGLES, 0, 18);

    //画外部边框
    glVertexAttrib4f(_colorSlot, 0.0, 0.0, 0.0, 1);

    glDrawArrays(GL_LINE_STRIP, 0, 18);
}

- (void)displayContents:(CADisplayLink *)sender {
    GLfloat rotateX = self.modelRotate.x;
    rotateX += M_PI_4 * 0.01;
    
    GLfloat rotateY = self.modelRotate.y;
    rotateY += M_PI_2 * 0.01;
    
    GLfloat rotateZ = self.modelRotate.z;
    rotateZ += M_PI * 0.01;
    
    self.modelRotate = GLKVector3Make(rotateX, rotateY, rotateZ);
    [self updateMat];
}
@end
