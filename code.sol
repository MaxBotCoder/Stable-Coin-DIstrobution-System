//SPDX-License-Identifier: MIT
pramga solidity 0.8.0;

contract StableCoinOffering {

	address Admin;
	
	struct ListingInfo {
		
	}
	
	mapping(msg,sender => ListingInfo) public Listing;
	
	struct PersonalPurchaseInfo {
	}
	
	mapping(msg.sender => PersonalPurchaseInfo) public PurchasesMade;
	
	contructor(){
		Admin = msg.sender;
	}
	
	function AlterStableCoinOffering() {
	
	}
	
	function InvestInStableCoin() public {
	
	}
	
}

contract LoanOffering {

	address Admin;
	
	struct ListingInfo {
	}
	
	mapping(msg,sender => ListingInfo) public Listing; 	
	
	struct PersonalPurchaseInfo {
	}
	
	mapping(msg.sender => PersonalPurchaseInfo) public PurchasesMade;
	
	contructor(){
		Admin = msg.sender;
	}
	
	function AlterLoanAttributes(){
	
	}
	
	function GetLoan () public {
	
	}
	
}

contract Administrator {
	
	address Admin;
	
	constructor () {
		Admin = msg.sender;
	}
	
	struct ContractHosted {
	}
	
	mapping(address => ContractHosted) public ListingOrLoanInfo;
	
	function CreateLoanOrListing (String _ContratType) public {
		require(_ContractType = "Stable Coin" || "StableCoin" || "Loan" || "loan", "Invalid Request.");
		if(_ContractType = "Stable Coin" || "StableCoin") {
		} else if (_ContractType = "Loan" || "loan") {
		}	 
	}
}
