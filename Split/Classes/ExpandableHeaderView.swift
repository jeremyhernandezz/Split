//
//  ExpandableHeaderView.swift
//  Split
//
//  Created by Jeremy Hernandez on 7/9/20.
//  Copyright © 2020 Jeremy Hernandez. All rights reserved.
//

import UIKit

//Created protocol
protocol ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int)
}

//Class that was created to store sections inside a tableview
class ExpandableHeaderView: UITableViewHeaderFooterView {

    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    
    override init(reuseIdentifier: String?){
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    //Required function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Selector function to select header action 
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        
        let cells = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cells.section)
        
    }
    //Initializer 
    func customInit(title: String, section: Int, delegate: ExpandableHeaderViewDelegate){
        self.textLabel?.text = title
        self.section = section
        self.delegate = delegate
    }
    
    //Changes the color properties of the cells
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.textColor = UIColor.white
        self.contentView.backgroundColor = UIColor.systemGreen
    }
    
    

}
