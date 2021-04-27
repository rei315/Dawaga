//
//  TutorialViewController.swift
//  Dawaga
//
//  Created by 김민국 on 2021/04/27.
//

import RxSwift

class TutorialViewController: UIViewController {

    // MARK: - UI Initialization
    
    private lazy var tutorialView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()
    
    private lazy var tutorialPage: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = UIColor.middleBlue
        pc.currentPageIndicatorTintColor = UIColor.systemOrange
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private lazy var tutorialDoneButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = UIColor.systemOrange
        bt.layer.cornerRadius = 8
        bt.tintColor = .white
        bt.setTitle(AppString.TutorialDoneTitle.localized(), for: .normal)
        bt.isHidden = true
        bt.addTarget(self, action: #selector(onTutorialDoneButton), for: .touchUpInside)
        return bt
    }()
    
    
    // MARK: - Property
    
    private var tutorialImages: [UIImage] = []
    
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTutorialView()
        self.configurePage()
    }

    
    // MARK: - Function

    private func configurePage() {
        Observable.just(tutorialImages.count)
            .bind(to: tutorialPage.rx.numberOfPages)
            .disposed(by: disposeBag)
        
        let page = tutorialView.rx.didScroll
            .withLatestFrom(tutorialView.rx.contentOffset)
            .map { Int(round($0.x / self.view.frame.width)) }
            .share()
        
        page
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] page in
                let maxPage = tutorialImages.count - 1
                
                if page == maxPage && tutorialDoneButton.isHidden {
                    self.animateTutorialDoneButton(state: .Up)
                    return
                }
                if page != maxPage && !tutorialDoneButton.isHidden {
                    self.animateTutorialDoneButton(state: .Down)
                    return
                }
            })
            .disposed(by: disposeBag)
        
        page
            .bind(to: tutorialPage.rx.currentPage)
            .disposed(by: disposeBag)
    }
    
    @objc private func onTutorialDoneButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UI Setup
extension TutorialViewController {
    
    private func setupTutorialView() {
        view.addSubview(tutorialView)
        view.addSubview(tutorialPage)
        view.addSubview(tutorialDoneButton)
            
        
        tutorialView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tutorialPage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(70)
        }
        
        switch Locale.current.languageCode {
        case "en":
            tutorialImages.append(UIImage(named: "tutorial_eng_1") ?? UIImage())
            tutorialImages.append(UIImage(named: "tutorial_eng_2") ?? UIImage())
            tutorialImages.append(UIImage(named: "tutorial_eng_3") ?? UIImage())
            tutorialImages.append(UIImage(named: "tutorial_eng_4") ?? UIImage())
        case "ko":
            tutorialImages.append(UIImage(named: "tutorial_ko_1") ?? UIImage())
            tutorialImages.append(UIImage(named: "tutorial_ko_2") ?? UIImage())
            tutorialImages.append(UIImage(named: "tutorial_ko_3") ?? UIImage())
            tutorialImages.append(UIImage(named: "tutorial_ko_4") ?? UIImage())
        case "ja":
            tutorialImages.append(UIImage(named: "tutorial_ja_1") ?? UIImage())
            tutorialImages.append(UIImage(named: "tutorial_ja_2") ?? UIImage())
            tutorialImages.append(UIImage(named: "tutorial_ja_3") ?? UIImage())
            tutorialImages.append(UIImage(named: "tutorial_ja_4") ?? UIImage())
        case .none:
            tutorialImages.append(UIImage(named: "tutorial_eng_1") ?? UIImage())
            tutorialImages.append(UIImage(named: "tutorial_eng_2") ?? UIImage())
            tutorialImages.append(UIImage(named: "tutorial_eng_3") ?? UIImage())
            tutorialImages.append(UIImage(named: "tutorial_eng_4") ?? UIImage())
            break
        case .some(_):
            break
        }
        
        let pageWidth = self.view.frame.width
        
        tutorialView.contentSize = CGSize(width: CGFloat(tutorialImages.count) * self.view.frame.maxX, height: self.view.frame.height)
                
        tutorialImages.enumerated().forEach { index, image in
            let backView = UIView()
            let iv = UIImageView()
            iv.image = image
            iv.contentMode = .scaleAspectFit
            backView.addSubview(iv)
            
            tutorialView.addSubview(backView)
            
            let offset = CGFloat(index) * pageWidth
            
            backView.snp.makeConstraints { (make) in
                make.width.equalTo(view.frame.width)
                make.height.equalTo(view.frame.height)
                make.left.equalToSuperview().offset(offset)
                make.centerY.equalToSuperview()
            }
            
            iv.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.top.equalTo(tutorialPage.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
            }
        }
        
        tutorialPage.numberOfPages = tutorialImages.count
        
        tutorialDoneButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(50)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(50)
        }
    }

}


// MARK: - DoneButton Animation
extension TutorialViewController {
    
    enum TutorialDoneButtonAnimation { case Up, Down }
    
    private func animateTutorialDoneButton(state: TutorialDoneButtonAnimation) {
        switch state {
        case .Up:
            tutorialDoneButton.isHidden = false
            tutorialDoneButton.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(-100)
            }
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            
        case .Down:
            tutorialDoneButton.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(50)
            }
            self.tutorialDoneButton.isHidden = true
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
