//
//  CardPaymentV.swift
//  HearBk
//
//  Created by PC on 08/01/19.
//  Copyright © 2019 PC. All rights reserved.
//

import UIKit
import DropDown

let CARD_NUMBER_CHAR = 16
let CARD_NUMBER_DASH_CHAR = 3

class CardPaymentV: UIView , UITextFieldDelegate , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var titleLbl: Label!
    
    @IBOutlet weak var addNewCardBtn: Button!
    @IBOutlet weak var cardTblView: UITableView!
    @IBOutlet weak var constraintHeightCardTbl: NSLayoutConstraint!
    
    @IBOutlet var savedCardBackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var cancelNewCardBavkView: UIView!
    @IBOutlet var newCardCancelBtnBackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addCardView: UIView!
    @IBOutlet weak var constraintHeightAddCardView: NSLayoutConstraint!//360
    
    @IBOutlet weak var cardNumberTxt: TextField!
    @IBOutlet weak var cardHolderNameTxt: TextField!
    @IBOutlet weak var monthTxt: TextField!
    @IBOutlet weak var yearTxt: TextField!
    @IBOutlet weak var securityCodeTxt: TextField!
    
    @IBOutlet weak var amountTxt: TextField!
    @IBOutlet weak var tearmsBtn: Button!
    
    @IBOutlet var accountContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var FundHbkBtn: Button!
    
    @IBOutlet var amountViewHeightConstraint: NSLayoutConstraint!
    
    
    var selectedScreen = Int()
    var isNewCard : Bool = false
    var isRegisterd : Bool = false
    var isApper : Bool = false
    var requiredAmount : Float = 0
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CardPaymentV", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        if cardTblView == nil {
            delay(0) {
                self.setup()
            }
            return
        }
        if isApper
        {
            return
        }
        isApper = true
        
        cardTblView.register(UINib.init(nibName: "CustomCardTVC", bundle: nil), forCellReuseIdentifier: "CustomCardTVC")
        cardNumberTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        cardTblView.reloadData()
        
        amountTxt.isUserInteractionEnabled = true
        
        if selectedScreen == 1 || selectedScreen == 2 {
            
            if selectedScreen == 1
            {
                amountTxt.isUserInteractionEnabled = false
                amountTxt.text = "99.00"
                FundHbkBtn.setTitle("Upgrade", for: .normal)
                titleLbl.text = "Payment Method"
            }
            else if selectedScreen == 2 {
                if requiredAmount > 0
                {
                    amountTxt.text = String(requiredAmount)
                }
                FundHbkBtn.setTitle("Fund HBK Account", for: .normal)
                titleLbl.text = "Fund HBK Account"
            }
            
            if AppModel.shared.CARD_LIST.count == 0 {
                isNewCard = true
                addNewCardBtn.isHidden = true
                savedCardBackViewHeightConstraint.constant = 0
                cancelNewCardBavkView.isHidden = true
                newCardCancelBtnBackViewHeightConstraint.constant = 0
                constraintHeightAddCardView.constant = 255
                accountContainerHeightConstraint.constant = 60 + 255 + 200
            } else {
                addNewCardBtn.isHidden = false
                isNewCard = false
                constraintHeightCardTbl.constant = self.getCardTblHeight()
                constraintHeightAddCardView.constant = 0
                addCardView.isHidden = true
                savedCardBackViewHeightConstraint.constant = self.getCardTblHeight() + 47
                accountContainerHeightConstraint.constant = self.getCardTblHeight() + 297 + self.constraintHeightAddCardView.constant
            }
        }
    }
    
    //MARK: - Button click event
    @IBAction func clickToBack(_ sender: Any) {
        self.endEditing(true)
        self.removeFromSuperview()
    }
    
    @IBAction func clickToAddCard(_ sender: Button) {
        self.endEditing(true)
        isNewCard = true
        addCardView.isHidden = false
        constraintHeightAddCardView.constant = 280
        
        addNewCardBtn.isHidden = true
        accountContainerHeightConstraint.constant = cardTblView.contentSize.height + 293 + constraintHeightAddCardView.constant
        updateAccpuntContainerHeight()
    }
    
    @IBAction func clickToCloseCardView(_ sender: Any) {
        self.endEditing(true)
        addCardView.isHidden = true
        constraintHeightAddCardView.constant = 0
        
        isNewCard = false
        addNewCardBtn.isHidden = false
        
        savedCardBackViewHeightConstraint.constant = cardTblView.contentSize.height + 47
        accountContainerHeightConstraint.constant = cardTblView.contentSize.height + 47 + 200 + 60
    
        updateAccpuntContainerHeight()
    }
    
    @IBAction func clickToSelectMonth(_ sender: UIButton) {
        self.endEditing(true)
        
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = getMonthArray()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.monthTxt.text = getMonthArray()[index]
        }
        dropDown.show()
    }
    
    @IBAction func clickToSelectYear(_ sender: UIButton) {
        self.endEditing(true)
        
        let dropDown = DropDown()
        dropDown.anchorView = sender
        dropDown.dataSource = getCardYearArray()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.yearTxt.text = getCardYearArray()[index]
        }
        dropDown.show()
        
    }
    
    @IBAction func clickToFundHBKAccount(_ sender: Any) {
        self.endEditing(true)
        
        if !isNewCard
        {
            if amountTxt.text?.trimmed == ""
            {
                displayToast("Please enter amount")
            }
            else
            {
                addFundToWallet()
            }
        }
        else
        {
            if cardHolderNameTxt.text?.trimmed == ""
            {
                displayToast("Please enter card name")
            }
            else if cardNumberTxt.text?.trimmed == ""
            {
                displayToast("Please enter card number")
            }
            else if monthTxt.text?.trimmed == "" || yearTxt.text?.trimmed == ""
            {
                displayToast("Please enter select expiry date")
            }
            else if securityCodeTxt.text?.trimmed == ""
            {
                displayToast("Please enter cvv")
            }
            else
            {
                var year : String = String((yearTxt.text?.dropFirst())!)
                year = String(year.dropFirst())
                var param : [String : Any] = [String : Any]()
                param["card_number"] = sendDetailByRemovingChar((cardNumberTxt.text?.trimmed)!, char:"-")
                param["exp_month"] = monthTxt.text
                param["exp_year"] = year
                param["cvc"] = securityCodeTxt.text
                param["card_holder_name"] = cardHolderNameTxt.text
                print(param)
                
               APIManager.shared.serviceCallToAddCard(param) { (status) in
                    if status {
                        self.constraintHeightCardTbl.constant = self.getCardTblHeight()
                        self.accountContainerHeightConstraint.constant = self.constraintHeightCardTbl.constant + 293
                        self.updateAccpuntContainerHeight()
                        self.cardTblView.reloadData()
                        NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CARD_DATA), object: nil)
                        let view1 : AlertV = AlertV.instanceFromNib() as! AlertV
                        
                        displaySubViewtoParentView(UIApplication.topViewController()?.view, subview: view1)
                        UIApplication.topViewController()?.view.addSubview(view1)
                        
                        view1.selectScreen = self.selectedScreen
                        
                        view1.alertBackGroundBtn.isUserInteractionEnabled = false
                        view1.futureTransactionView.isHidden = false
                        view1.congratulationView.isHidden = true
                        view1.paymentFailedView.isHidden = true
                        view1.successView.isHidden = true
                        
                        if self.selectedScreen != 3 {
                            self.addFundToWallet()
                        }
                        else {
                            self.removeFromSuperview()
                        }
                        
                    } else {
                        self.removeFromSuperview()
                        let view1 : AlertV = AlertV.instanceFromNib() as! AlertV
                        
                        displaySubViewtoParentView(UIApplication.topViewController()?.view, subview: view1)
                        UIApplication.topViewController()?.view.addSubview(view1)
                        
                        view1.alertBackGroundBtn.isUserInteractionEnabled = false
                        view1.futureTransactionView.isHidden = true
                        view1.congratulationView.isHidden = true
                        view1.paymentFailedView.isHidden = false
                        view1.successView.isHidden = true
                    }
                }
            }
        }
    }
   
    //MARK: Card Tearms condition section
    @available(iOS 10.0, *)
    @IBAction func clickToTearmsConditions(_ sender: Any) {
        self.endEditing(true)
        let vc : TermsAndConditionVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
        vc.pdfSelection = "HearBK_Terms_of_Use_"
        UIApplication.topViewController()!.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickToAgreeTearmsConditions(_ sender: UIButton) {
        self.endEditing(true)
        tearmsBtn.isSelected = !tearmsBtn.isSelected
    }

    
    func addFundToWallet()
    {
        if amountTxt.text?.trimmed == ""
        {
            displayToast("Please enter amount")
            return
        }
        if selectedScreen == 1  {
            if AppModel.shared.currentUser.wallet_balance >= 99 {
                continuesUpgradeAccount()
            } else {
                self.continueToFundAccount()
            }
            
        } else {
            self.continueToFundAccount()
        }
    }
    
    func continueToFundAccount()
    {
        if AppModel.shared.CARD_LIST.count == 0
        {
            displayToast("Please add card.")
            return
        }
        var param : [String : Any] = [String : Any]()
        if getDefaultCardID() != "" {
            param["card_id"] = getDefaultCardID()
        }else{
            param["card_id"] = AppModel.shared.CARD_LIST[0].id
        }
        
        param["amount"] = self.amountTxt.text
        
        APIManager.shared.serviceCallToAddFundsWithSaveCard(param, {
            
            AppModel.shared.currentUser.wallet_balance = AppModel.shared.currentUser.wallet_balance + Float(self.amountTxt.text!)!
            NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CURRENT_USER_DATA), object: nil)
            
            if self.selectedScreen == 1  {
                self.continuesUpgradeAccount()
            }
            else
            {
                self.removeFromSuperview()
            }
        })
    }
    
    func continuesUpgradeAccount()  {
        APIManager.shared.serviceCallToUpgradeAccount {
            AppModel.shared.currentUser.account_type = 1
            self.removeFromSuperview()
            NotificationCenter.default.post(name: NSNotification.Name.init("REDIRECT_TO_BACK"), object: nil)
        }
    }
    
    //MARK: - Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return AppModel.shared.CARD_LIST.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cardTblView != nil && !isRegisterd {
            setup()
            isRegisterd = true
        }
        
            let cell : CustomCardTVC = cardTblView.dequeueReusableCell(withIdentifier: "CustomCardTVC", for: indexPath) as! CustomCardTVC
            let dict : CardModel = AppModel.shared.CARD_LIST[indexPath.row]
            cell.cardNameLbl.text = dict.name
            cell.cardNumberLbl.text = "**** **** **** " + dict.last4
            cell.cardTypeBtn.setImage(UIImage.init(named: dict.brand.lowercased()), for: .normal)
            var year : String = String((dict.exp_year?.dropFirst())!)
            year = String(year.dropFirst())
            cell.expireLbl.text =  dict.exp_month + "/" + year
            cell.deleteCard.tag = indexPath.row
            cell.deleteCard.addTarget(self, action: #selector(clickToDeleteCard(_:)), for: .touchUpInside)
            cell.checkBtn.isSelected = (getDefaultCardID() == dict.id)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == cardTblView {
            setDefaultCardID(AppModel.shared.CARD_LIST[indexPath.row].id)
            cardTblView.reloadData()
        }
    }
    
    @IBAction func clickToDeleteCard(_ sender: UIButton) {
        self.endEditing(true)
        showAlertWithOption("Delete", message: "Are you sure you want to delete this card?", completionConfirm: {
            let dict : CardModel = AppModel.shared.CARD_LIST[sender.tag]
            APIManager.shared.serviceCallToDeleteCard(dict.id) {
                
                if getDefaultCardID() == dict.id
                {
                    setDefaultCardID("")
                }
                AppModel.shared.CARD_LIST.remove(at: sender.tag)
                self.cardTblView.reloadData()
                self.constraintHeightCardTbl.constant = self.getCardTblHeight()
                self.savedCardBackViewHeightConstraint.constant = self.getCardTblHeight() + 43
                self.accountContainerHeightConstraint.constant = self.getCardTblHeight() + 293 + self.constraintHeightAddCardView.constant
                NotificationCenter.default.post(name: NSNotification.Name.init(NOTIFICATION.UPDATE_CARD_DATA), object: nil)
            }
        }) {
            
        }
    }

    
    //MARK: - Add/delete/view Card Methods
    func getCardTblHeight() -> CGFloat
    {
        return CGFloat(90 * AppModel.shared.CARD_LIST.count)
    }
    
    func updateAccpuntContainerHeight()
    {
        if accountContainerHeightConstraint.constant > (SCREEN.HEIGHT - 30)
        {
            accountContainerHeightConstraint.constant = (SCREEN.HEIGHT - 30)
        }
    }
    
    //MARK: - UITextField Delegate
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(textField == cardNumberTxt){
            cardNumberTxt.text = showCardNumberFormattedStr(cardNumberTxt.text!, isRedacted: false)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(string == ""){
            return true
        }
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        
        if(textField == cardNumberTxt){
            var maxLength:Int = 0
            maxLength = CARD_NUMBER_CHAR + CARD_NUMBER_DASH_CHAR
            let str:String = cardNumberTxt.text!
            return str.count < maxLength
        }
        else if textField == securityCodeTxt
        {
            return newLength <= 3
        }
        return true
    }

}
