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
#include <stack>
#include <queue>
#include <vector>
#include <string>
using namespace std;

typedef struct TreeNode{
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
}TreeNode;

typedef struct ListNode{
    int val;
    struct ListNode *next;
}ListNode;

typedef struct ListNodes{
    int val;
    struct ListNodes *next;
    struct ListNodes *pre;
}ListNodes;

//class Stack{
//public:
//    int len;
//    void push(TreeNode *node);
//    TreeNode *pop();
//};

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
//    testTree();
//    testMaxGap();
//    testTreeMirror();
//    testReverseAllStr();
//    testIsPopOrder();
//    testVerifySquenceOfBST();
    
//    testTwoTreeToList();
//    testString();
//    testArrValExceedHalf();
    testStlHeapSort();
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

#pragma -mark 链表算法
//创建链表
ListNode *createList(int *arr,int num){
    ListNode *headNode = NULL;
    ListNode *nextNode = NULL;
    for(int i=0;i<num;i++){
        ListNode *tNode = new ListNode();
        tNode->val = arr[i];
        if(headNode==NULL){
            headNode = tNode;
        }
        if(nextNode){
            nextNode->next = tNode;
        }
        nextNode = tNode;
    }
    if(nextNode){
        nextNode->next = NULL;
    }
    return headNode;
}
//显示链表
void showList(ListNode *list){
    while (list) {
        printf("%d,",list->val);
        list = list->next;
    }
    printf("\n");
}

//排序两个有序链表（非递归）
ListNode *sortTwoList(ListNode *list1, ListNode *list2){
    if(list1==NULL) return list2;
    if(list2==NULL) return list1;
    
    ListNode *headNode = new ListNode();
    ListNode *nextNode = headNode;
    while (true) {
        if(list1==NULL){
            nextNode->next = list2;
            break;
        }
        if(list2==NULL){
            nextNode->next = list1;
            break;
        }
        if(list1->val<list2->val){
            nextNode->next = list1;
            list1 = list1->next;
        }else{
            nextNode->next = list2;
            list2 = list2->next;
        }
        nextNode = nextNode->next;
    }
    return headNode->next;
}
//递归
ListNode *sortTwoListRecursion(ListNode *list1, ListNode *list2){
    if(list1==NULL) return list2;
    if(list2==NULL) return list1;
    
    ListNode *headNode;
    if(list1->val<list2->val){
        headNode = list1;
        headNode->next = sortTwoListRecursion(list1->next, list2);
    }else{
        headNode = list2;
        headNode->next = sortTwoListRecursion(list1, list2->next);
    }
    return headNode;
}
void testSortTwoList(){
    int arr1[] = {2,5,7,9,10,13,16,17};
    int arr2[] = {3,5,7,9,16,19,20,22,45,67};
    ListNode *list1 = createList(arr1, sizeof(arr1)/sizeof(int));
    showList(list1);
    ListNode *list2 = createList(arr2, sizeof(arr2)/sizeof(int));
    showList(list2);
    
//    ListNode *list = sortTwoList(list1, list2);
    ListNode *list = sortTwoListRecursion(list1, list2);
    showList(list);
}

//输出链表中倒数第k个节点
ListNode *findListNodeByKey(ListNode *headNode,int k){
    if(headNode==NULL||k<=0){
        return NULL;
    }
    ListNode *frontNode = headNode;
    for(int i=0;i<k-1;i++){
        if(frontNode==NULL){
            return NULL;
        }
        frontNode = frontNode->next;
    }
    while (frontNode->next) {
        frontNode = frontNode->next;
        headNode = headNode->next;
    }
    return headNode;
}

void testFindListNodeByKey(){
    int arr1[] = {3,5,7,9,16,19,20,22,45,67};
    ListNode *list1 = createList(arr1, sizeof(arr1)/sizeof(int));
    ListNode *findNode = findListNodeByKey(list1, 20);
    showList(findNode);
}

//寻找带环的链表的入库
ListNode *findEntryNode(ListNode *headNode){
    if(headNode==NULL)
        return NULL;
    //1、证明有环
    ListNode *aHeadNode = headNode;
    ListNode *behindNode = headNode;
    while (true) {
        aHeadNode = aHeadNode->next;
        if(aHeadNode==NULL)
            return NULL;
        aHeadNode = aHeadNode->next;
        if(aHeadNode==NULL)
            return NULL;
        behindNode = behindNode->next;
        if(aHeadNode==behindNode){
            break;
        }
    }
    //2、得到环的节点数
    int num = 0;
    while (true) {
        aHeadNode = aHeadNode->next;
        num++;
        if(aHeadNode==behindNode){
            break;
        }
    }
    //3、找倒数的第k个节点
    ListNode *entryNode = findListNodeByKey(headNode, num);
    return entryNode;
}

//反转链表
void testReversalList(){
    int arr1[] = {3,5,7,9,16,19,20,22,45,67};
    ListNode *list1 = createList(arr1, sizeof(arr1)/sizeof(int));
    list1 = reversalList(list1);
    showList(list1);
}
ListNode *reversalList(ListNode *headNode){
    if(headNode==NULL)
        return NULL;
    ListNode *preNode = NULL;
    ListNode *newNode = headNode;
    ListNode *nextNode = newNode->next;
    while (newNode) {
        newNode->next = preNode;
        if(nextNode==NULL){
            break;
        }
        preNode = newNode;
        newNode = nextNode;
        nextNode = newNode->next;
        
    }
    return newNode;
}

#pragma -mark tree
void testTree(){
    int a[] = {10,6,14,4,-1,-1,16};
    TreeNode *headNode = createTree(a, sizeof(a)/sizeof(int), 0);
//    preShowTree1(headNode);
    cenShowTree1(headNode);
//    vector<int> vec;
//    showTreePath(headNode, &vec, 0, 18);
//    int max = 0;
//    countMaxTreePath(headNode,0,max);
//    printf("countMaxTreePath>>>%d",max);
    return;
    int maxPath = 0;
    int currentSum = 0;
//    countMaxTreePath(headNode, currentSum, maxPath);
    
    vector<int> tmpVec, retVec;
    countMaxTreePath1(headNode, currentSum, maxPath, &tmpVec, &retVec);
    
    NSLog(@"maxPath=%d",maxPath);
    
    vector<int>::iterator iter = retVec.begin();
    for(;iter!=retVec.end();iter++){
        printf("%d,",*iter);
    }
    printf("\n");
}
//将数组转换为树
TreeNode *createTree(int *a,int n,int k){
    if(k>=n){
        return NULL;
    }
    if(a[k]==-1){
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
    stack<TreeNode *> s;
//    stack.push(headNode);
    TreeNode *node = headNode;
    while (node||!s.empty()) {
        if(node){
            s.push(node);
            printf("%d,",node->val);
            node = node->left;
        }
        else{
            node = s.top();
            s.pop();
            node = node->right;
        }
    }
}

//从上到下打印二叉树
void cenShowTree(TreeNode *headNode){
    if(headNode==NULL){
        return;
    }
    queue<TreeNode *> q;
    q.push(headNode);
    while (!q.empty()) {
        TreeNode *node = q.front();
        q.pop();
        printf("%d,",node->val);
        if(node->left){
            q.push(node->left);
        }
        if(node->right){
            q.push(node->right);
        }
    }
    printf("\n");
}

//从上到下分层打印二叉树
void cenShowTree1(TreeNode *headNode){
    if(headNode==NULL){
        return;
    }
    queue<TreeNode *> q;
    q.push(headNode);
    int curCenCount = 1;
    int nextCenCount = 0;
    while (!q.empty()) {
        TreeNode *node = q.front();
        
        if(node->left){
            q.push(node->left);
            nextCenCount++;
        }
        if(node->right){
            q.push(node->right);
            nextCenCount++;
        }
        
        q.pop();
        curCenCount--;
        printf("%d ",node->val);
        if(curCenCount<=0){
            curCenCount = nextCenCount;
            nextCenCount = 0;
            //换行
            printf("\n");
        }
    }
    printf("\n");
}

//输出为某值的所有路径
void showTreePath(TreeNode *headNode,vector<int> *vec,int sum,int val){
    if(!headNode)
        return;
    sum = sum + headNode->val;
    vec->push_back(headNode->val);
    if(headNode->left==NULL&&headNode->right==NULL&&sum==val){
        vector<int>::iterator iter = vec->begin();
        for(;iter!=vec->end();++iter){
            printf("%d\t",*iter);
        }
        printf("\n");
    }
    showTreePath(headNode->left, vec, sum, val);
    showTreePath(headNode->right, vec, sum, val);
//    sum = sum - headNode->val;
    vec->pop_back();
}

//计算所有路径的最大权重值
void countMaxTreePath(TreeNode *headNode,int currentSum,int &max){
    if(headNode){
        currentSum += headNode->val;
        if(headNode->left==NULL&&headNode->right==NULL){
            //到叶节点了
            if(currentSum>max) max = currentSum;
        }
        countMaxTreePath(headNode->left,currentSum, max);
        countMaxTreePath(headNode->right,currentSum, max);
//        currentSum = currentSum - headNode->val;
    }
}
//计算所有路径的最大权重值，并输出路径
void countMaxTreePath1(TreeNode *headNode,int currentSum,int &max,vector<int> *tmpVec,vector<int> *retVec){
    if(tmpVec==NULL || retVec==NULL){
        return;
    }
    if(headNode){
        currentSum += headNode->val;
        tmpVec->push_back(headNode->val);
        if(headNode->left==NULL&&headNode->right==NULL){
            //到叶节点了
            if(currentSum>max){
                max = currentSum;
                while (!retVec->empty()) {
                    retVec->pop_back();
                }
                vector<int>::iterator iter = tmpVec->begin();
                for(;iter!=tmpVec->end();iter++){
                    retVec->push_back(*iter);
                }
            }
        }
        countMaxTreePath1(headNode->left,currentSum, max, tmpVec, retVec);
        countMaxTreePath1(headNode->right,currentSum, max, tmpVec, retVec);
        currentSum = currentSum - headNode->val;
        tmpVec->pop_back();
    }
}


//二叉树的镜像
void testTreeMirror(){
//    int a[] = {1,2,3,4,5,6,7};
    int a[] = {1,2,2,4,5,5,7};
    TreeNode *headNode = createTree(a, sizeof(a)/sizeof(int), 0);
//    cenShowTree(headNode);
//
//    treeMirror(headNode);
//    cenShowTree(headNode);
    
    printf("treeSymmetry>>>%d",treeSymmetry(headNode));
    
}
void treeMirror(TreeNode *tree){
    
    if(!tree) return;
    if(tree->left||tree->right){
        //交换
        TreeNode *tmp = tree->left;
        tree->left = tree->right;
        tree->right = tmp;
    }
    treeMirror(tree->left);
    treeMirror(tree->right);
}

//对称二叉树
bool treeSymmetry(TreeNode *tree){
    return treeIsSymmetry(tree->left, tree->right);
}

bool treeIsSymmetry(TreeNode *tree1,TreeNode *tree2){
    if(tree1==NULL&&tree2==NULL)
        return 1;
    if(tree1==NULL||tree2==NULL)
        return 0;
    if(tree1->val!=tree2->val){
        return 0;
    }
    bool isDui = 0;
    isDui = treeIsSymmetry(tree1->left,tree2->right);
    if(isDui){
        isDui = treeIsSymmetry(tree1->right,tree2->left);
    }
    return isDui;
}

//判断是否为二叉搜索树的后序遍历
void testVerifySquenceOfBST(){
//    int arr[] = {5,7,6,9,11,10,8};
    int arr[] = {7,4};
    printf("testVerifySquenceOfBST>>>>%d",verifySquenceOfBST(arr, sizeof(arr)/sizeof(int)));
}
bool verifySquenceOfBST(int squ[],int len){
    if(len<1)
        return 0;
    if(len<2)
        return 1;
    int cenPot = squ[len-1];
    //分成左右两部分
    int *lFirst = squ;
    int *rFirst = squ;
    for(int i=0;i<len-1;i++){
        if(squ[i]>cenPot){
            break;
        }
        if(squ[i]==cenPot){
            return 0;
        }
        rFirst += 1;
    }
    if(rFirst-lFirst+1>len-1){
        //没有右树
        rFirst = NULL;
    }else if(rFirst==squ){
        //没有左树
        lFirst = NULL;
    }

    if(rFirst){
        int plen = len - 1 - (rFirst - squ);
        //如果右树有小值，也是不合法的
        for(int i=0;i<plen;i++){
            if(rFirst[i]<=cenPot){
                return 0;
            }
        }
        if(!verifySquenceOfBST(rFirst, plen)){
            return 0;
        }
    }
    if(lFirst){
        int plen = 0;
        if(!rFirst){
            plen = len - 1;
        }else{
            plen = rFirst - squ;
        }
        if(!verifySquenceOfBST(lFirst, plen)){
            return 0;
        }
    }
    return 1;
}

//搜索二叉树转换成排序的双向链表，不能创建新节点
void testTwoTreeToList(){
    int a[] = {10,6,14,4,8,12,16};
    TreeNode *headNode = createTree(a, sizeof(a)/sizeof(int), 0);
    
    TreeNode *listNode = NULL, *curNode = NULL;
    twoTreeToList(headNode, &listNode, &curNode);
    
//    cenShowTree(listNode);
    while (listNode) {
        printf("%d\t",listNode->val);
        listNode = listNode->right;
    }
    printf("\n");
    
}
void twoTreeToList(TreeNode *headTree,TreeNode **headList,TreeNode **curNode){
    if(headTree==NULL)
        return;
    
    twoTreeToList(headTree->left,headList,curNode);
    //值
    if(*headList==NULL){
        *headList = headTree;
    }else{
        (*curNode)->right = headTree;
        headTree->left = *curNode;
    }
    *curNode = headTree;
    twoTreeToList(headTree->right,headList,curNode);
}

#pragma -mark 字符串
void testString(){
    char str[] = "abcd";
//    stringAllArrange(str);
    stringAllGroup(str);
}
//字符串的排列
void stringAllArrange(char *str){
    if(str==NULL){
        return;
    }
    
    stringAllArrangeSub(str, str);
}

void stringAllArrangeSub(char *str,char *pStr){
    if(*pStr=='\0'){
        printf("%s\n",str);
        return;
    }
    for(int i=0;i<strlen(pStr);i++){
        char tmp = *pStr;
        *pStr = pStr[i];
        pStr[i] = tmp;
        
        stringAllArrangeSub(str,pStr+1);
        
        tmp = *pStr;
        *pStr = pStr[i];
        pStr[i] = tmp;
    }
}

//求字符串的所有组合
void stringAllGroup(char *str){
    if(str==NULL){
        return;
    }
    for(int i=1;i<=strlen(str);i++){
        vector<char> vec;
        stringAllGroupSub(str, i,&vec);
    }
}

void stringAllGroupSub(char *str,int n,vector<char> *vec){
    if(strlen(str)<n){
        return;
    }
    if(n<=0){
        vector<char>::iterator iter = vec->begin();
        for(;iter!=vec->end();++iter){
            printf("%c",*iter);
        }
        printf("\n");
        return;
    }
    if(*str=='\0'){
        return;
    }
//    printf("%c",*str);
    vec->push_back(*str);
    stringAllGroupSub(str+1,n-1,vec);
    vec->pop_back();
    stringAllGroupSub(str+1,n,vec);
}

#pragma -mark other

//b是否为a栈的弹出系列
void testIsPopOrder(){
    int a[] = {1,2,3,4,5};
    int b[] = {4,5,3,1,2};
    printf("isPopOrder>>>%d\n",isPopOrder(a, b, sizeof(a)/sizeof(int)));
}
bool isPopOrder(int *a,int *b,int len){
    stack<int> stk;
    int bidx = 0;
    int aidx = 0;
    while (bidx<len) {
        int vb = b[bidx];
        if(!stk.empty()&&stk.top()==vb){
            //比较下一个
            bidx++;
            stk.pop();
        }else{
            if(aidx>=len)
                return 0;
            int va = a[aidx++];
            stk.push(va);
        }
        
    }
    return 1;
}

//数组中出现次数超过一半的的数字
void testArrValExceedHalf(){
//    int arr[] = {6,4,7,4,2,4,4,4,6,8};
    int arr[] = {4};
    printf("arrValExceedHalf>>>%d",arrValExceedHalf(arr, sizeof(arr)/sizeof(int)));
}
int arrValExceedHalf(int *arr,int len){
    //运用部分快排的思维
    if(arr==NULL||len<1)
        return -1;
    int mid = len/2;
    int start = 0;
    int end = len - 1;
    int idx = partitionQuickSort(arr, start, end);
    while (idx!=mid) {
        if(idx<mid){
            start = idx + 1;
        }else{
            end = idx - 1;
        }
        idx = partitionQuickSort(arr, start, end);
    }
    //检查idx对应的值是否超过一半
    int num = 0;
    int ret = arr[idx];
    for(int i=0;i<len;i++){
        if(ret==arr[i]){
            num++;
        }
    }
    if(num<=mid)
        return -1;
    return ret;
}

//最小的k个数

#pragma -mark 排序
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
//快速排序 时间 O(nlog2(n)) 空间 O(nlog2(n)) 不稳定
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


//测试stl的堆排序
void printVec(string head,vector<int> vec){
    printf("%s: ",head.c_str());
    vector<int>::iterator iter = vec.begin();
    for(;iter!=vec.end();iter++){
        printf("%d,",*iter);
    }
    printf("\n");
}
void testStlHeapSort(){
    vector<int> vec{6,1,2,5,3,4};
    printVec("vec:",vec);
    make_heap(vec.begin(), vec.end(), greater<int>());
    printVec("最小堆:",vec);
    make_heap(vec.begin(), vec.end(), less<int>());
    printVec("最大堆",vec);
    
    //往最大堆插入数值
    vec.push_back(10);
    push_heap(vec.begin(), vec.end());
    printVec("插入值10",vec);
    
    //输出最大堆的最大值
    int max = vec[0];
    pop_heap(vec.begin(), vec.end());
    printVec("最大值pop：",vec);
    vec.pop_back();
    
    //输出排序后的
    sort_heap(vec.begin(), vec.end());
    printVec("排序：",vec);
    
}

//所有的组合
void allPart(char *begin,int len,vector<char> *q){
    
    if(len==0){
        for(int i=0;i<q->size();i++){
            printf("%c",(*q)[i]);
        }
        printf("\n");
        return;
    }
    if(*begin=='\0'){
        return;
    }
    char ic = *begin;
    q->push_back(ic);
    allPart(begin+1, len-1, q);
    q->pop_back();
    allPart(begin+1, len, q);
}
void allPartMain(char *s,int len){
    
    for(int i=1;i<=len;i++){
        vector<char> q;
        allPart(s, i, &q);
    }
}
void testAllPart(){
    
    char *s = "abcd";
    allPartMain(s, 4);
}

//计算最大差值
void testMaxGap(){
    //如下的数组，最大差值是5与16，并且必须是先5再16，跟股票交易一样
    int arr[] = {9, 11, 8, 5, 7, 12, 16, 14};
    
    int size = sizeof(arr)/sizeof(int);
    if(size<2) return;
    int min = arr[0];
    int maxDiff = arr[1] - arr[0];
    for(int i=2;i<sizeof(arr)/sizeof(int);i++){
        if(arr[i-1]<min)
            min = arr[i-1];
        
        if(arr[i]-min>maxDiff){
            maxDiff = arr[i] - min;
        }
    }
    
    printf("max=%d",maxDiff);
}

//翻转字符串
void reverseStr(char *s,char *e)
{
    if(s==NULL||e==NULL) return;
    while (s<e) {
        char t = *s;
        *s = *e;
        *e = t;
        s++;
        e--;
    }
}

void testReverseAllStr(){
    //I am a student   变为  student a am I
    char str[] = "I am a student";
    int len = (int)strlen(str);
    if(len<2) return;
    char *s = str;
    char *e = s + len - 1;
    
    reverseStr(s, e);
    
    s = e = str;
    while (*e != '\0') {
        if(*s == ' '){
            s++;
        }else if(*e != '\0' && *e==' '){
            reverseStr(s, e-1);
            s = e+1;
        }
        e++;
    }
    
    printf("str=%s",str);
}

@end
