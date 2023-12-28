//
//  String+Ext.swift
//  mk_swift_wawaji
//
//  Created by sander shan on 2022/12/8.
//

import UIKit
import SwiftDate

extension String {
    func toTimeStamp(_ format: String? = nil) -> Double {
        let rome = Region(calendar: Calendars.gregorian, zone: Zones.asiaShanghai, locale: Locales.chinese)
        let toDate = self.toDate(format, region: rome);
        guard toDate != nil else { return 0 }
        let toDateTimeStamp = toDate!.timeIntervalSince1970
        return toDateTimeStamp;
    }
    func toDate(_ format: String? = nil) -> DateInRegion? {
        let rome = Region(calendar: Calendars.gregorian, zone: Zones.asiaShanghai, locale: Locales.chinese)
        let toDate = self.toDate(format, region: rome);
        return toDate;
    }
}
