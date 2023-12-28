//
//  SDApplePayClient.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/11/23.
//

import UIKit
import StoreKit

import RxSwift
import RxCocoa

protocol ApplePayClientType {
    func pay(_ projectId: String) -> Single<(Int, String)>
    func restoreCompletedTransactions() -> Single<(Int, String)>
    func putCurrentPaymentProjectId(projectId: String);
    func finishCurrentPayment() -> Single<Bool>
    func getLastPaymentProjectId() -> String?;
}

class SDApplePayClient: NSObject, ApplePayClientType {
    func restoreCompletedTransactions() -> RxSwift.Single<(Int, String)> {
        if self.getLastPaymentProjectId() == nil {
            return .never();
        }
        return Single<(Int, String)>.create { [unowned self] single in
            self.restoreCompletedTransactions { (code, receipt) in
                single(.success((code, receipt!)))
            }
            return Disposables.create {
                self.paySuccessHandler = nil;
            }
        }
    }
    
    func pay(_ projectId: String) -> RxSwift.Single<(Int, String)> {
        return Single<(Int, String)>.create { [unowned self] single in
            self.payForProject(projectId) { (code, receipt) in
                single(.success((code, receipt!)))
            }
            return Disposables.create {
                self.paySuccessHandler = nil;
            }
        }
    }
    func putCurrentPaymentProjectId(projectId: String) {
        UserDefaults.standard.set(projectId, forKey: KeylastPaymentProject);
        UserDefaults.standard.synchronize();
    }
    func finishCurrentPayment() -> Single<Bool> {
        UserDefaults.standard.set(nil, forKey: KeylastPaymentProject);
        UserDefaults.standard.synchronize();
        guard let tansaction = self.lastTansaction else { return Single.just(false)}
        SKPaymentQueue.default().finishTransaction(tansaction);
        return Single.just(true);
    }
    func getLastPaymentProjectId() -> String? {
        return UserDefaults.standard.object(forKey: KeylastPaymentProject) as? String;
    }
    
    typealias PayFinishHandler = (Int, String?) -> Void;
    
    private var paySuccessHandler: PayFinishHandler?
    
    let KeylastPaymentProject = "lastPaymentProject";
    
    
    private var lastTansaction: SKPaymentTransaction? = nil;
    
    override init() {
        super.init();
        SKPaymentQueue.default().add(self);
        if self.getLastPaymentProjectId() != nil {
            /// 回复之前的购买
            SKPaymentQueue.default().restoreCompletedTransactions();
        }
    }
    deinit {
        SKPaymentQueue.default().remove(self);
    }
}

private extension SDApplePayClient {
    
    func restoreCompletedTransactions(payHandler: PayFinishHandler? = nil) {
        SKPaymentQueue.default().restoreCompletedTransactions();
        self.paySuccessHandler = payHandler;
    }
    func payForProject(_ projectId: String, payHandler: PayFinishHandler? = nil) {
        log.debug("[现在去支付]---> \(projectId)")
        if SKPaymentQueue.canMakePayments() {
            self.paySuccessHandler = payHandler;
            self.getProductInfo(projectId);
        } else {
            guard let handler = paySuccessHandler else { return }
            handler(-1, "不支持应用内付费购买");
        }
    }
    
    func getProductInfo(_ projectId: String) {
        let set : Set<String> = Set([projectId]);
        let request = SKProductsRequest.init(productIdentifiers: set);
        request.delegate = self;
        request.start();
    }
    func completeTransaction(tansaction: SKPaymentTransaction) {
        let appstoreRequest = URLRequest(url: Bundle.main.appStoreReceiptURL!);
        if let receiptData = try? NSURLConnection.sendSynchronousRequest(appstoreRequest, returning: nil) {
            let transactionReceiptString = receiptData.base64EncodedString(options: [.endLineWithLineFeed])
            log.debug("[购买凭证] -> \(transactionReceiptString)");
            guard self.paySuccessHandler != nil else { return }
            self.lastTansaction = tansaction;
            self.paySuccessHandler!(0,transactionReceiptString);
        }
    }
    func failedTransaction(tansaction: SKPaymentTransaction) {
        log.debug("[购买失败] ---> \(tansaction.error)")
        guard self.paySuccessHandler != nil else { return }
        self.paySuccessHandler!(-1, "购买失败")
    }
    func restoreTransaction(tansaction: SKPaymentTransaction) {
        log.debug("[恢复购买]")
        if self.getLastPaymentProjectId() != nil {
            self.completeTransaction(tansaction: tansaction);
        }
    }
}

extension SDApplePayClient: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchased:
                self.completeTransaction(tansaction: transaction);
                break;
            case .failed:
                self.failedTransaction(tansaction: transaction);
                break;
            case .restored:
                self.restoreTransaction(tansaction: transaction)
                break;
            case .purchasing: break;
            default: break;
            }
        }
    }

}
extension SDApplePayClient: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let myProject = response.products;
        if myProject.count == 0 {
            guard self.paySuccessHandler != nil else { return }
            self.paySuccessHandler!(-1, "无法获取产品信息，购买失败。")
            return;
        }
        let payment = SKPayment.init(product: myProject.first!);
        SKPaymentQueue.default().add(payment);
    }
    
}

struct PayError: Error {
    let message: String;
}
