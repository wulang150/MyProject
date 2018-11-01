//
//  CollectDataMacro.h
//  BleMultiConnect
//
//  Created by WANG DONG on 2018/5/30.
//  Copyright © 2018年 WANG DONG. All rights reserved.
//

#ifndef CollectDataMacro_h
#define CollectDataMacro_h


#define FOLDER_NAME @"HeartRate"

//上传所有Log信息到服务器
static NSString *const HttpCollectDataPostURL = @"https://pro.smartfenda.com/collect_data/upload.php";
//static NSString *const HttpCollectDataPostURL = @"http://collect.smartfenda.cn/upload.php";

//上传信息对应的Key和Value
#define OTHER_KEY   @"EB5BC16ED1CDCE40200392E3D8D79193"
#define OTHER_IV    @"800D99BCF87E37073574F4AF8DE7CB7C"

#define APPID_COLLECT_DATA @"23512"

#define COLLECT_HEALTH_DATA @"Health"

#endif /* CollectDataMacro_h */
