public with sharing class pdQuotation {
    public pdQuotation() {
        // 見積IDを取得する
        quoteId = ApexPages.currentPage().getParameters().get('id');
    }

    /**
    * 見積ID
    */
    private Id quoteId;

    /**
     * 見積タイトル
     */
    public String title { get; set; }

    /**
    * 取引先名
    */
    public String accountName { get; set; }

    /**
    * 取引先住所
    */
    public String accountPostalCode { get; set; }
    public String accountAddress1 { get; set; }
    public String accountAddress2 { get; set; }

    /**
    * 取引先担当者
    */
    public String contactName { get; set; }

    /**
    * 見積番号
    */
    public String quoteNumber { get; set; }

    /**
    * 見積日
    */
    public Date quoteDate { get; set; }

    /**
    * 有効期限
    */
    public String expirationDate { get; set; }

    /**
    * 会社名
    */
    public String companyName { get; set; }

    /**
    * 会社住所
    */
    public String companyPostalCode { get; set; }
    public String companyAddress1 { get; set; }
    public String companyAddress2 { get; set; }

    /**
    * 会社電話番号
    */
    public String companyPhone { get; set; }

    /**
    * 会社担当者
    */
    public String employeeName { get; set; }

    /**
    * 会社担当者メールアドレス
    */
    public String mailAddress { get; set; }

    /**
    * 見積明細
    */
    public List<QuoteLineItem> quoteDetail { get; set; }

    /**
    * 小計
    */
    public Decimal subTotal { get; set; }

    /**
    * 消費税
    */
    public Decimal tax { get; set; }

    /**
    * 合計
    */
    public Decimal total { get; set; }

    /**
    * 備考
    */
    public String memo { get; set; }

    /**
     * 税込表示
     */
    public Boolean isTaxIncluded { get; set; }
    /**
     * 税抜表示
     */
    public Boolean isTaxNotIncluded { get; set; }

    /**
    * 見積を印刷するために必要なデータを取得する
    */
    public void doPrint() {
        // 現在のユーザ情報を取得する
        User user = [SELECT Id,CompanyName,PostalCode,State,City,Street,Phone,LastName,FirstName,Email
            FROM User
            WHERE Id=:UserInfo.getUserId()];

        // 会社情報を設定する
        // 会社名
        companyName = user.CompanyName;
        // 会社住所
        companyPostalCode = user.PostalCode;
        companyAddress1 = user.State + user.City;
        if (user.Street != null) {
            String[] companyStreet = user.Street.split('\r\n');
            if (companyStreet.size() >= 1) {
                companyAddress1 += companyStreet[0];
            }
            if (companyStreet.size() >= 2) {
                companyAddress2 = companyStreet[1];
            }
        }
        // 会社電話番号
        companyPhone = user.Phone;
        // 社員名
        employeeName = user.LastName + ' ' + user.FirstName;
        // メールアドレス
        mailAddress = user.Email;

        // 見積情報を取得する
        Quote quote = [SELECT Id,Name,
            Account.FullName__c,Account.BillingPostalCode,Account.BillingState,Account.BillingCity,Account.BillingStreet,
            Contact.FirstName, Contact.LastName,TaxType__c,
            QuoteNumber__c, QuoteDate__c, ExpirationDate__c, Subtotal, Tax, GrandTotal, Description, Memo__c
            FROM Quote
            WHERE Id=:quoteId];
        // 取引先名
        accountName = quote.Account.FullName__c;
        // 取引先郵便番号
        accountPostalCode = quote.Account.BillingPostalCode;
        // 取引先住所
        accountAddress1 = quote.Account.BillingState + quote.Account.BillingCity;
        if (quote.Account.BillingStreet != null) {
            String[] accountStreet = quote.Account.BillingStreet.split('\r\n');
            if (accountStreet.size() >= 1) {
                accountAddress1 += accountStreet[0];
            }
            if (accountStreet.size() >= 2) {
                accountAddress2 = accountStreet[1];
            }
        }
        // 見積タイトル
        title = quote.QuoteNumber__c + quote.Name;
        // 取引先担当者名
        contactName = null;
        if (quote.Contact.LastName != null) {
            contactName = quote.Contact.LastName;
            if (quote.Contact.FirstName != null) {
                contactName += ' ' + quote.Contact.FirstName;
            }
        }
        // 見積番号
        quoteNumber = quote.QuoteNumber__c;
        // 見積日
        quoteDate = quote.QuoteDate__c;
        // 有効期限
        expirationDate = quote.ExpirationDate__c;
        // 小計
        subTotal = quote.Subtotal;
        // 消費税
        tax = quote.Tax;
        // 合計
        total = quote.GrandTotal;
        // 備考
        if (quote.Memo__c != null) {
            memo = quote.Memo__c.replace('\r\n', '<br />');
        }
        // 消費税表示
        isTaxIncluded = (quote.taxType__c == '税込');
        isTaxNotIncluded = (quote.taxType__c == '税抜');

        // 見積明細情報を取得する
        quoteDetail = [SELECT Id,Description,UnitPrice,Quantity,Unit__c,Subtotal
            FROM QuoteLineItem
            WHERE QuoteId=:quoteId
            ORDER BY SortOrder];

        // 見積明細が8行未満なら8行になるまで空明細を追加する
        if (quoteDetail == null) {
            quoteDetail = new List<QuoteLineItem>();
        }
        for (Integer i=quoteDetail.size() ; i<8 ; i++) {
            QuoteLineItem item = new QuoteLineItem();
            quoteDetail.add(item);
        }
    }
}
