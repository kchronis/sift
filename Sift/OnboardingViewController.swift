//
//  OnboardingViewController.swift
//  Sift
//
//  Created by Kyle Chronis on 2/25/17.
//  Copyright © 2017 Kyle Chronis. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    let viewModel : OnboardingViewModel
    var currentQuestion: OnboardingViewModel.Question = .needFilter
    var currentQuestionView : OnboardingQuestionView!
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initial setup
        self.view.backgroundColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
        // create first questionView
        self.currentQuestionView = self.createQuestionView(question: self.currentQuestion)
        self.currentQuestionView.animateIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func transitionQuestionView() {
        if let question = self.currentQuestion.next() {
            let finishedQuestionView = self.currentQuestionView
            self.currentQuestion = question
            self.currentQuestionView = self.createQuestionView(question: question)
            finishedQuestionView?.animateOut(completionHandler: { (finished) in
                finishedQuestionView?.removeFromSuperview()
            })
            self.currentQuestionView.animateIn()
        }
        else {
            // Finished questions, present timeline
            self.presentTimeline()
        }
    }
    
    private func presentTimeline() {
        let timelineNavigationController = UINavigationController(
            rootViewController: TimelineViewController(
                viewModel: TimelineViewModel(account: self.viewModel.account)
            )
        )
        self.present(
            timelineNavigationController,
            animated: true,
            completion: nil
        )
    }
    
    private func createQuestionView(question: OnboardingViewModel.Question) -> OnboardingQuestionView {
        let questionView = OnboardingQuestionView(
            header:self.viewModel.header(question: question),
            buttonTitles: self.viewModel.buttonTitles(question: question),
            buttonAlignment: self.questionViewAlignment(for: question),
            selectionHandler: { [unowned self] (index: Int) in
                self.viewModel.setFilterForSelection(question: question, index: index)
                // HACK(KC) early exit for decling filtering
                if question == .needFilter && index == 1 {
                    self.presentTimeline()
                }
                else {
                    self.transitionQuestionView()
                }
        })
        questionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(questionView)
        
        questionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        questionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        questionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        questionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.view.layoutIfNeeded()
        
        return questionView
    }
    
    // HACK:(KC) Couldn't find a better place to retrieve the alignment for the question.
    private func questionViewAlignment(for question: OnboardingViewModel.Question) -> OnboardingQuestionView.ButtonAlignment {
        switch question {
        case .needFilter:
            return OnboardingQuestionView.ButtonAlignment.horizontal
        case .filterType:
            return OnboardingQuestionView.ButtonAlignment.horizontal
        case .filterTime:
            return OnboardingQuestionView.ButtonAlignment.vertical
        }
    }
}
