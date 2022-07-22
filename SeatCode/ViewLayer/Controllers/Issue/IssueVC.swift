//
//  IssueVC.swift
//  SeatCode
//
//  Created by Javier Calatrava on 21/7/22.
//
import UIKit
import JGProgressHUD

protocol IssueVCProtocol: AnyObject {
    func presentActivityIndicator()
    func removeActivityIndicator()
    func dismiss()
    func refreshView(issueVM: IssueVM)
    func presentAlertFormNotProperyFullfilled()
}
class IssueVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var issueView: IssueView!

    // MARK: - Callback
    var onDismiss: () -> Void = { /* Default empty block */ }

    // MARK: - Private attributes
    private var presenter: IssuePresenterProtocol?
    //  var issueVM: IssueVM?
    private let hud = JGProgressHUD()

    // MARK: - Constructor/Initializer
    public static func instantiate(presenter: IssuePresenterProtocol/* = IssuePresenter(), issueVM: IssueVM*/) -> IssueVC {
        let storyboard = UIStoryboard(name: R.storyboard.main.name, bundle: nil)
        guard let issuesVC = storyboard.instantiateViewController(withIdentifier: String(describing: IssueVC.self)) as? IssueVC else {
            return IssueVC()
        }
        issuesVC.presenter = presenter
        presenter.set(issueVC: issuesVC)
        return issuesVC
    }


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViewController()
    }

    // MARK: - Private
    private func setupViewController() {

        title = R.string.localizable.issue_title.key.localized

        hud.textLabel.text = R.string.localizable.trips_loading.key.localized

        let issueVM = presenter?.getIssue()
        self.issueView.set(issueVM: issueVM)
        self.issueView.onNameValueChanged = { [weak self] value in
            guard let weakSelf = self else { return }
            weakSelf.presenter?.onNameValueChanged(value: value)
        }
        self.issueView.onSurenameValueChanged = { [weak self] value in
            guard let weakSelf = self else { return }
            weakSelf.presenter?.onSurenameValueChanged(value: value)
        }
        self.issueView.onEmailValueChanged = { [weak self] value in
            guard let weakSelf = self else { return }
            weakSelf.presenter?.onEmailValueChanged(value: value)
        }
        self.issueView.onTimestampValueChanged = { [weak self] value in
            guard let weakSelf = self else { return }
            weakSelf.presenter?.onTimestampValueChanged(value: value)
        }
        self.issueView.onReportValueChanged = { [weak self] value in
            guard let weakSelf = self else { return }
            weakSelf.presenter?.onReportValueChanged(value: value)
        }
        self.issueView.onPhoneValueChanged = { [weak self] value in
            guard let weakSelf = self else { return }
            weakSelf.presenter?.onPhoneValueChanged(value: value)
        }
        self.issueView.onSaveAction = { [weak self] in
            Task {
                guard let weakSelf = self else { return }
                await weakSelf.presenter?.onSaveAction()
            }
        }
    }

    private func isFormProperlyFilled() -> Bool {
        presenter?.isProperlyFilled() ?? false
    }
}

extension IssueVC: IssueVCProtocol {

    func refreshView(issueVM: IssueVM) {
        issueView.set(issueVM: issueVM)
    }

    func dismiss() {
        self.onDismiss()
    }

    func presentActivityIndicator() {
        hud.show(in: self.view)
    }

    func removeActivityIndicator() {
        hud.dismiss(animated: true)
    }

    func presentAlertFormNotProperyFullfilled() {
        let alert = UIAlertController(title: R.string.localizable.issue_alert_title.key.localized,
                                      message: R.string.localizable.issue_alert_message.key.localized,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: R.string.localizable.alert_continue.key.localized,
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
