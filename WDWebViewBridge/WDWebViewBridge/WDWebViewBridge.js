;(function() {
  var AppBridge = {
        init:function(){
        var appBridge = {};
        appBridge.bridgeArray = new Array();
        var WDBridge = {
                init:function(){
                var bridge = {};
                bridge.time_key = new Date().getTime();
                bridge.sendMessage;
                bridge.calback;
                //发送消息到app
                bridge.sendMessageToApp = function(message){
                    var url = "wdbridgesend://" + encodeURIComponent(message)
                    window.location.href = url;
                }
                //app接收到消息后的回调
                bridge.appReceiveFinish = function(message){
                    resposeAppReceiveFinish(message);
                }
                //监听app端发来的消息
                bridge.monitorAppMessage = function(message){
                    appMonitorAppMessage(message);
                }
                //发来之后给服务端一个回调响应，表示成功
                bridge.responseToApp = function(message){
                    var url = "wdbridgeresponse://" + encodeURIComponent(message)
                    window.location.href = url;
                }
                return bridge;
            }
        }
        //给app发消息
        appBridge.sendMessageToApp = function sendMessageToApp(message,calback){
            var bridge = WDBridge.init();
            bridge.calback =  calback;
            bridge.sendMessage = message;
            appBridge.bridgeArray.push(bridge);
            //重新封装json
            var json = "{\"time_key\":"+bridge.time_key+",\"message\":\""+message+"\"}";
            //发给app
            bridge.sendMessageToApp(json);
        }
  
        //app收到消息后的回调
        appBridge.appReceiveFinish = function appReceiveFinish(message){
            var messageObj = JSON.parse(message);
            //找到对应发出消息的bridge
            for(var i = 0;i<appBridge.bridgeArray.length;i++){
                var object = appBridge.bridgeArray[i];
                if(messageObj.time_key == object.time_key){
                //调用回调方法
                object.calback(object.sendMessage);
                }
            }
        }
        appBridge.receiveAppMessage;
        //监听app的发过来的消息
        appBridge.monitorAppMessage = function monitorAppMessage(message){
            var bridge = WDBridge.init();
            var messageObj = JSON.parse(message);
            var backMessage = messageObj.sendMessage;
            //将返回过来的消息通知服务器
            bridge.responseToApp(message);
            appBridge.receiveAppMessage(backMessage);
        }
        return appBridge;
    }
  }
  window.AppBridge = AppBridge.init();
})();
