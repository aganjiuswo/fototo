//
//  JXTitlePageDelegate.swift
//  fototo
//
//  Created by Even_cheng on 2019/10/11.
//  Copyright © 2019 Even_cheng All rights reserved.
//

import Foundation
import JXPhotoBrowser

/// 实现了以 数字型 为页码指示器的 Delegate.
open class JXTitlePageDelegate: JXPhotoBrowserBaseDelegate {
    
    typealias GetTitleBlock = (_ index: Int)->(String?)
    var getTitle:GetTitleBlock?
    
    /// 字体
    open var font = UIFont.systemFont(ofSize: 17)
    
    /// 字颜色
    open var textColor = UIColor.white

    /// 指定Y轴从顶部往下偏移值
    open lazy var offsetY: CGFloat = {
        if #available(iOS 11.0, *), let window = UIApplication.shared.keyWindow {
            return window.safeAreaInsets.top
        }
        return 20
    }()
    
    /// 标题指示
    open lazy var pageControl: UILabel = {
        let view = UILabel()
        view.font = font
        view.textColor = textColor
        view.textAlignment = NSTextAlignment.center
        return view
    }()
    
    open override func photoBrowser(_ browser: JXPhotoBrowser, pageIndexDidChanged pageIndex: Int) {
        super.photoBrowser(browser, pageIndexDidChanged: pageIndex)
        layout()
    }
    
    open override func photoBrowserViewWillLayoutSubviews(_ browser: JXPhotoBrowser) {
        super.photoBrowserViewWillLayoutSubviews(browser)
        layout()
    }
    
    open override func photoBrowser(_ browser: JXPhotoBrowser, viewDidAppear animated: Bool) {
        super.photoBrowser(browser, viewDidAppear: animated)
        // 页面出来后，再显示页码指示器
        // 多于一张图才添加到视图
        let totalPages = browser.itemsCount
        if totalPages > 1 {
            browser.view.addSubview(pageControl)
        }
    }
    
    open override func photoBrowserDidReloadData(_ browser: JXPhotoBrowser) {
        layout()
    }
    
    //
    // MARK: - Private
    //
    
    private func layout() {
        guard let browser = self.browser else {
            return
        }
        guard let superView = pageControl.superview else { return }
        let totalPages = browser.itemsCount
        if self.getTitle != nil {
            pageControl.text = self.getTitle!(browser.pageIndex)
        } else {
            pageControl.text = "\(browser.pageIndex + 1) / \(totalPages)"
        }
        pageControl.sizeToFit()
        pageControl.center.x = superView.bounds.width / 2
        pageControl.frame.origin.y = offsetY
        pageControl.isHidden = totalPages <= 1
    }

}
