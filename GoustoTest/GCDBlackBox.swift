//
//  GCDBlackBox.swift
//  InfiniteTableViewScrollingTask
//
//  Created by Alexey Chebotarev on 3/15/17.
//  Copyright © 2016 Alexey Chebotarev. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}


