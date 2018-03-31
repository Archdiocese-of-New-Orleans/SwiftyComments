//
//  RedditCommentsViewController.swift
//  Commenting
//
//  Created by Stéphane Sercu on 27/06/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import UIKit
import SwiftyComments

class FoldableRedditCommentsViewController: RedditCommentsViewController, CommentsViewDelegate {
    
    func commentCellExpanded(atIndex index: Int) {
        updateCellFoldState(false, atIndex: index)
    }
    
    func commentCellFolded(atIndex index: Int) {
        updateCellFoldState(true, atIndex: index)
    }
    
    private func updateCellFoldState(_ folded: Bool, atIndex index: Int) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! RedditCommentCell
        cell.isFolded = folded
        (self.currentlyDisplayed[index] as! RichComment).isFolded = folded
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    override func viewDidLoad() {
        self.fullyExpanded = true
        super.viewDidLoad()
        self.delegate = self
        
        self.swipeToHide = true
        self.swipeActionColor = RedditConstants.flashyColor
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCom: AbstractComment = currentlyDisplayed[indexPath.row]
        let selectedIndex = indexPath.row
        
        if selectedCom.replies.count == 0 {
            if (selectedCom as! RichComment).isFolded {
                commentCellExpanded(atIndex: selectedIndex)
            } else {
                commentCellFolded(atIndex: selectedIndex)
            }
        } else {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }
    
    
}
class RedditCommentsViewController: CommentsViewController {
    private let commentCellId = "redditComentCellId"
    var allComments: [RichComment] = [] // All the comments (nested, not in a linear format)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(RedditCommentCell.self, forCellReuseIdentifier: commentCellId)
        
        tableView.backgroundColor = RedditConstants.backgroundColor
        
        allComments = RandomDiscussion.generate().comments
        
        currentlyDisplayed = allComments
    }
    
    override open func commentsView(_ tableView: UITableView, commentCellForModel commentModel: AbstractComment, atIndexPath indexPath: IndexPath) -> CommentCell {
        let commentCell = tableView.dequeueReusableCell(withIdentifier: commentCellId, for: indexPath) as! RedditCommentCell
        let comment = currentlyDisplayed[indexPath.row] as! RichComment
        commentCell.level = comment.level
        commentCell.commentContent = comment.body
        commentCell.posterName = comment.posterName
        commentCell.date = comment.soMuchTimeAgo()
        commentCell.upvotes = comment.upvotes
        commentCell.isFolded = comment.isFolded
        commentCell.delegate = self
        return commentCell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = RedditConstants.flashyColor
        self.navigationController?.navigationBar.tintColor = .white
        UIApplication.shared.statusBarStyle = .lightContent
    }
}

class FoldableRedditCommentCell: RedditCommentCell {
    
    
    
}
