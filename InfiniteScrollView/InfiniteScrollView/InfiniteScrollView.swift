//
//  InfiniteScrollView.swift
//  InfiniteScrollView
//
//  Created by Brian Doyle on 8/18/19.
//  Copyright © 2019 Balance Software. All rights reserved.
//

// Swift port of Apple's InfiniteScrollView.m

import UIKit

class InfiniteScrollView: UIScrollView {
    let labelContainerView = UIView()
    var visibleLabels = [UILabel]()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentSize = CGSize(width: 5000, height: UIScreen.main.bounds.height)

        labelContainerView.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height / 2)
        labelContainerView.isUserInteractionEnabled = false

        addSubview(labelContainerView)

        // hide horizontal scroll indicator so our recentering trick is not revealed
//        showsHorizontalScrollIndicator = false
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func recenterIfNecessary() {
        let currentOffset = contentOffset
        let contentWidth = contentSize.width
        let centerOffsetX = (contentWidth - bounds.size.width) / 2
        let distanceFromCenter = abs(currentOffset.x - centerOffsetX)

        guard distanceFromCenter > contentWidth / 4 else { return }

        contentOffset = CGPoint(x: centerOffsetX, y: currentOffset.y)

        for label in visibleLabels {
            var center = labelContainerView.convert(label.center, to: self)
            center.x += centerOffsetX - currentOffset.x
            label.center = convert(center, to: labelContainerView)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        recenterIfNecessary()

        let visibleBounds = convert(bounds, to: labelContainerView)
        let minX = visibleBounds.minX
        let maxX = visibleBounds.maxX

        tileLabels(from: minX, to: maxX)
    }

    func tileLabels(from minimumVisibleX: CGFloat, to maximumVisibleX: CGFloat) {
        // we require at least one label
        if visibleLabels.isEmpty {
            placeNewLabelOnRight(minimumVisibleX)
        }

        // add labels that are missing on the right side
        var lastLabel = visibleLabels.last!
        var rightEdge = lastLabel.frame.maxX

        while rightEdge < maximumVisibleX {
            rightEdge = placeNewLabelOnRight(rightEdge)
        }

        // add labels that are missing on the left side
        var firstLabel = visibleLabels[0]
        var leftEdge = firstLabel.frame.minX

        while leftEdge > minimumVisibleX {
            leftEdge = placeNewLabelOnLeft(leftEdge)
        }

        // remove labels that have fallen off the right edge
        lastLabel = visibleLabels.last!

        while lastLabel.frame.origin.x > maximumVisibleX {
            lastLabel.removeFromSuperview()
            visibleLabels.removeLast()
            lastLabel = visibleLabels.last!
        }

        // remove labels that have fallen off the left edge
        firstLabel = visibleLabels[0]
        while firstLabel.frame.maxX < minimumVisibleX {
            firstLabel.removeFromSuperview()
            visibleLabels.remove(at: 0)
            firstLabel = visibleLabels[0]
        }
    }

    func makeLabel() -> UILabel {
        let frame = CGRect(x: 0, y: 0, width: 500, height: 80)
        let label = UILabel(frame: frame)
        label.numberOfLines = 3
        label.text = "1024 Block Street\nShaeffer, CA\n95014"
        labelContainerView.addSubview(label)

        let layer = label.layer
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1

        return label
    }

    @discardableResult func placeNewLabelOnRight(_ rightEdge: CGFloat) -> CGFloat {
        let label = makeLabel()
        visibleLabels.append(label)

        var frame = label.frame
        frame.origin.x = rightEdge
        frame.origin.y = labelContainerView.bounds.height - frame.height
        label.frame = frame

        return frame.maxX
    }

    func placeNewLabelOnLeft(_ leftEdge: CGFloat) -> CGFloat {
        let label = makeLabel()
        visibleLabels.insert(label, at: 0)

        var frame = label.frame
        frame.origin.x = leftEdge - frame.width
        frame.origin.y = labelContainerView.bounds.height - frame.height
        label.frame = frame

        return frame.minX
    }
}
