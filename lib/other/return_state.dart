//解析后端返回的数据
class ReturnState {
  late int code; //状态码 0 success 1 warning 2 error 3 info
  late String msg; //操作信息

  //快速构建一个返回状态
  ReturnState.unknown(this.code, this.msg);

  ReturnState.success(this.msg) : code = 0;

  ReturnState.warning(this.msg) : code = 1;

  ReturnState.error(this.msg) : code = 2;

  ReturnState.info(this.msg) : code = 3;

  // ReturnState(this.msg);

  //不懂dynamic能不能直接转换成Map<String,dynamic>
  factory ReturnState.fromJson(Map<String, dynamic> jsonData) {
    return ReturnState.unknown(jsonData['code'], jsonData['msg']);
  }
}
