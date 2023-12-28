//
//  SDTCPClient.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/16.
//

import UIKit

import CocoaAsyncSocket


protocol SDTCPClientType {
    func connect(address: String, port: Int, delegate: SDTCPClientDelegate);
    func disConnect();
    func sendTcp(data: SDBaseTcpData);
}

protocol SDTCPClientDelegate : class {
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16);
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?);
    func readTcpData(_ cmd: SDTCPResponseCMD, receviceData: Data);
}

class SDTCPClient: NSObject {
    var gcdSocket: GCDAsyncSocket?
    private var tcpAddress: String?
    private var tcpPort: Int?
    weak var delegate: SDTCPClientDelegate?
    
    // 外部 通知给到的 是不是可以链接
    private var canConnect = false;
    
    override init() {
        super.init();
    }
}
private extension SDTCPClient {
    func configClient() {
       
    }
    
    func dealData(receiveData: Data) {
        if receiveData.count < 4 {
            return
        }
        let headData = receiveData.subdata(in: 0..<4);
        let headStr = String.init(data: headData, encoding: .utf8);
        if headStr != "doll" {
            return
        }
        let lengthData = receiveData.subdata(in: 4..<8);
        let receiveLength = lengthData.lyz_4BytesToInt();
        if receiveData.count >= receiveLength {
            let data = receiveData.subdata(in: 8 ..< receiveLength);
            if let receviceDataStr = String.init(data: data, encoding: .utf8) {
                log.debug("[Socket] ---> \(receviceDataStr)");
                self.dealReceviceData(data: data);
                if let lastData = receiveData.subdata(in: receiveLength ..< receiveData.count) as? Data {
                    if lastData.count > 0 {
                        self.dealData(receiveData: lastData);
                    }
                }
            }
        }
    }
    func dealReceviceData(data: Data) {
        if let receviceData = try? JSONDecoder().decode(SDBaseTcpResponse.self, from: data) {
            log.debug("[Socket] dealReceviceData ---> \(receviceData.cmd)");
            if let delegate = self.delegate {
                delegate.readTcpData(SDTCPResponseCMD(rawValue: receviceData.cmd)!, receviceData: data);
            }
        }
    }
}

extension SDTCPClient: SDTCPClientType {
    func sendTcp(data: SDBaseTcpData) {
        guard self.gcdSocket != nil else {return}
        guard let sendData = data.getSendData() else {return}
        self.gcdSocket?.write(sendData, withTimeout: -1, tag: 0);
        log.debug("[Socket] ---> sendTcp: \(data.cmd)");
    }
    
    func disConnect() {
        guard self.gcdSocket != nil else { return }
        self.gcdSocket?.disconnect();
        self.canConnect = false;
    }
    
    func connect(address: String, port: Int, delegate: SDTCPClientDelegate) {
        self.tcpAddress = address;
        self.tcpPort = port;
        self.delegate = delegate;
        self.canConnect = true;
        self.gcdSocket = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue(label: "com.ydd.socket"))
        guard self.gcdSocket != nil else {return}
        do {
            try self.gcdSocket?.connect(toHost: self.tcpAddress!, onPort: UInt16(self.tcpPort!));
        } catch {
            log.debug("链接 失败 ---> \(error)")
        }
    }
}

extension SDTCPClient: GCDAsyncSocketDelegate {
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        log.debug("[didAcceptNewSocket] ----> ")
    }
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        /// connect to Host
        log.debug("[didConnectToHost] ----> ")
        
        guard let delegate = self.delegate else {return}
        delegate.socket(sock, didConnectToHost: host, port: port);
    }
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        log.debug("[SOCKET] ---> didRead -->");
        self.dealData(receiveData: data);
    }
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
//        log.debug("[socketDidDisconnect] ----> \(err)")
        guard let delegate = self.delegate else {return}
        delegate.socketDidDisconnect(sock, withError: err);
    }
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        log.debug("[Socket] ---> didWriteDataWithTag : \(tag)");
        sock.readData(withTimeout: -1, tag: tag);
    }
}
