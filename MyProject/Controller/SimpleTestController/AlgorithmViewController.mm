//
//		File Name:		AlgorithmViewController.m
//		Product Name:	MyProject
//		Author:			anker@Tmac
//		Created Date:	2020/3/26 10:34 AM
//		
// * Copyright © 2020 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
//		All rights reserved.
//'--------------------------------------------------------------------'
	

#import "AlgorithmViewController.h"

Class Stack{
    int val;
    void push(int a);
    int pop();
}

typedef struct TreeNode{
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
}TreeNode;

@interface AlgorithmViewController ()

@end

@implementation AlgorithmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavWithTitle:@"algo" leftImage:@"arrow" leftTitle:nil leftAction:nil rightImage:nil rightTitle:nil rightAction:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    testTree();
    return;
    
    int a[] = {45,23,32,16,100,78,56,29,33,23,17};
    int n = sizeof(a)/sizeof(int);
    NSLog(@"src Arr:");
    showArr(a, n);
    
//    mergeSort(a, 0, n-1);
//    quickSort(a, 0, n-1);
    heapSort(a, n);
    
    NSLog(@"result Arr:");
    showArr(a, n);
}

void showArr(int a[],int n){
    NSString *str = @"";
    for(int i=0;i<n;i++){
        str = [NSString stringWithFormat:@"%@%d,",str,a[i]];
    }
    NSLog(str);
}

void testTree(){
    int a[] = {45,23,32,16,100,78,56,29,33,23,17};
    TreeNode *headNode = createTree(a, sizeof(a)/sizeof(int), 0);
    preShowTree(headNode);
}

TreeNode *createTree(int *a,int n,int k){
    if(k>=n){
        return NULL;
    }
    TreeNode *node = (TreeNode *)malloc(sizeof(TreeNode));
    node->val = a[k];
    node->left = createTree(a, n, 2*k+1);
    node->right = createTree(a, n, 2*k+2);
    return node;
}

//遍历，先序 递归
void preShowTree(TreeNode *headNode){
    if(headNode){
        printf("%d,",headNode->val);
        preShowTree(headNode->left);
        preShowTree(headNode->right);
    }
}
//非递归
void preShowTree1(TreeNode *headNode){
    
}

//归并排序 时间 O(nlog2(n)) 空间 O(n) 稳定
void mergeSort(int a[],int s,int e)
{
    if(s<e){
        //先拆分为一个个数字
        int mid = s+(e-s)/2;
        mergeSort(a, s, mid);
        mergeSort(a, mid+1, e);
        //每个拆分后的单个数字都认为是有序的，然后进行合并。一级级往上
        merge(a, s, mid, e);
    }
}
//对两个有序队列进行排序
void merge(int a[],int s,int mid,int e){
    int tmp[e-s+1], i = s, j = mid+1,k = 0;
    while (i<=mid&&j<=e&&i<j) {
        if(a[i]<a[j]){
            tmp[k++] = a[i++];
        }else{
            tmp[k++] = a[j++];
        }
    }
    
    while (i<=mid) {
        tmp[k++] = a[i++];
    }
    while (j<=e) {
        tmp[k++] = a[j++];
    }
    k = 0;
    while (s<=e) {
        a[s++] = tmp[k++];
    }
}

//void swap(int a[],int j,int k){
//    int tmp = a[j];
//    a[j] = a[k];
//    a[k] = tmp;
//}

void swap(int *a, int *b)
{
    int tmp = *a;
    *a = *b;
    *b = tmp;
}

//方法1
int partitionQuickSort(int a[],int s,int e){
    int n = e-s+1;
    int k=s;
    int index = rand()%n+s;
    int p = a[index];
    swap(&a[index], &a[e]);
    for(int i=s;i<e;i++){
        if(a[i]<p){
            swap(&a[i], &a[k]);
            k++;
        }
    }
    swap(&a[k], &a[e]);
    return k;
}
//方法2
//int partitionQuickSort(int a[], int low, int high)
//{
//    int privotKey = a[low];                                //基准元素
//    while(low < high){                                    //从表的两端交替地向中间扫描
//        while(low < high  && a[high] >= privotKey) --high;  //从high 所指位置向前搜索，至多到low+1 位置。将比基准元素小的交换到低端
//        swap(&a[low], &a[high]);
//        while(low < high  && a[low] <= privotKey ) ++low;
//        swap(&a[low], &a[high]);
//    }
////    print(a,10);
//    return low;
//}
//时间 O(nlog2(n)) 空间 O(nlog2(n)) 不稳定
void quickSort(int a[],int s,int e){
    if(s<e){
        int mid = partitionQuickSort(a, s, e);
        quickSort(a, s, mid-1);
        quickSort(a, mid+1, e);
    }
}

//对已经是堆的进行操作
void makeHeap(int a[],int s,int n){
    int p = s;
    int child = 2*p + 1;
    while (child<n) {
        if(child+1<n&&a[child]<a[child+1]){
            child++;
        }
        if(a[p]<a[child]){
            swap(&a[p], &a[child]);
            p = child;
            child = 2*p + 1;
        }else{
            break;
        }
    }
}
//构建堆
void createHeap(int a[],int n){
    //从底部开始调整
    for(int i=(n-1)/2;i>=0;i--){
        makeHeap(a, i, n);
    }
    printf("heap:");
    showArr(a, n);
}
//时间 O(nlog2(n)) 空间 O(1) 不稳定
void heapSort(int a[],int n){
    createHeap(a, n);
    for(int i=n-1;i>0;i--){
        swap(&a[i], &a[0]);
        makeHeap(a, 0, i);
    }
}
@end
