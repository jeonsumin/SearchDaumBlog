//
//  AlertActionConvertible.swift
//  SearchDaumBlog
//
//  Created by Terry on 2022/02/15.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style{ get }
}
