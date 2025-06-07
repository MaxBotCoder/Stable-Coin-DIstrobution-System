//SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract DispenserTypeContract {
	address public Admin;
	uint public PriceOfItem;
	
	constructor(){
		Admin = msg.sender;
	}
}

contract DataStorageTypeContract {
	address Admin;
	
	constructor(){
		Admin = msg.sender;
	}
}

contract DepositTypeContract {
	address Admin;
	uint public OverdrawAttemptLimit;
	
	mapping(address => uint) public TransactionNumber;
	mapping(address => uint) public AmountToWithdrawOrInput;
	mapping(address => uint) public AmountWithinTotaly;
	mapping(address => uint) public Recipient;
	mapping(address => uint) public TransactionNumber;
	mapping(address => uint) public MyOverdrawAttempts;
	mapping(address => bool) public MaximumOverdrawAttempts;
 	mapping(address => string) SpecificTransactionType;
	
	constructor(){
		Admin = msg.sender;
	}
	
	struct _SpecificTransaction {
		
		uint AmountStored;
		string TransactionType;
		uint QuantityTransfered;
		address From;
		address To;
		uint TransactionNumber;
	}
	
	mapping(address => mapping(uint => _SpecificTransaction) public SpecificTransaction;
	
	struct _CurrentTransaction {
		
		uint AmountStored;
		string TransactionType;
		uint QuantityTransfered;
		address From;
		address To;
		uint TransactionNumber;
		
	}
	
	mapping(address => _CurrentTransaction) public CurrentTransaction;
	
	function ContractConfiguration (uint _MaxOverdrawThreshold) {
		require(msg.sender == Admin);
		OverdrawAttemptLimit = _MaxOverdrawThreshold;
	}
	
	function (string _TransactionType, uint _QuantityInOrOut, address _PossibleRecipient) payable public {
		require(_TransactionType == "Deposit" || _TransactionType == "deposit" || _TransactionType == "Withdraw" || _TransactionType == "withdraw", "Not an option.");
		
		if(TransactionType == "Deposit" || TransactionType == "deposit"){
		
			AmountToWithdrawOrInput[msg.sender] = _QuantityInOrOut;
			require (AmountToWithdrawOrInput[msg.sender] > CurrentTransition[msg.sender].AmountStored);
			TransactionNumber[msg.sender] += 1;
			Recipient[msg.sender] = _PossibleRecipient;
			SpecificTransactionType[msg.sender] = _TransactionType;
			AmountWithinTotaly[msg.sender] += AmountToWithdrawOrInput[msg.sender];
			CurrentTransaction[msg.sender] = _CurrentTransaction( AmountWithinTotaly[msg.sender], SpecificTransactionType[msg.sender], AmountToWithdrawOrInput[msg.sender], msg.sender, Recipient[msg.sender], TransactionNumber[msg.sender]);
			SpecificTransaction[msg.sender][TransactionNumber[msg.sender]] = CurrentTransaction[msg.sender];
			
		} else if (TransactionType == "Withdraw" || TransactionType == "withdraw") {
			
			if(CurrentTransaction[msg.sender].AmountStored < AmountToWithdrawOrInput[msg.sender]) {
				MyOverdrawAttempts[msg.sender] += 1;
			}
			
			if(MyOverdrawAttempts[msg.sender] < OverdrawAttemptLimit) {
			
				require(CurrentTransaction[msg.sender].AmountStored >= AmountToWithdrawOrInput[msg.sender], "Overdraw attempts are recorded, do not hit the limit threshold or further attempts will be punished with a gas penalty.");
				payable(_PossibleRecipient).call{value: _QuantityInOrOut}("");
				TransactionNumber[msg.sender] += 1;
				Recipient[msg.sender] = _PossibleRecipient;
				SpecificTransactionType[msg.sender] = _TransactionType;
				AmountWithinTotaly[msg.sender] += AmountToWithdrawOrInput[msg.sender];
				CurrentTransaction[msg.sender] = _CurrentTransaction( AmountWithinTotaly[msg.sender], SpecificTransactionType[msg.sender], AmountToWithdrawOrInput[msg.sender], msg.sender, Recipient[msg.sender], TransactionNumber[msg.sender]);
			SpecificTransaction[msg.sender][TransactionNumber[msg.sender]] = CurrentTransaction[msg.sender];
			
			} else if (OverdrawAttemptLimit == MyOverdrawAttempts[msg.sender]) {
			
				assert(CurrentTransaction[msg.sender].AmountStored >= AmountToWithdrawOrInput[msg.sender]);
				payable(_PossibleRecipient).call{value: _QuantityInOrOut}("");
				TransactionNumber[msg.sender] += 1;
				Recipient[msg.sender] = _PossibleRecipient;
				SpecificTransactionType[msg.sender] = _TransactionType;
				AmountWithinTotaly[msg.sender] += AmountToWithdrawOrInput[msg.sender];
				CurrentTransaction[msg.sender] = _CurrentTransaction( AmountWithinTotaly[msg.sender], SpecificTransactionType[msg.sender], AmountToWithdrawOrInput[msg.sender], msg.sender, Recipient[msg.sender], TransactionNumber[msg.sender]);
			SpecificTransaction[msg.sender][TransactionNumber[msg.sender]] = CurrentTransaction[msg.sender];
			
			}
		}
	}
}

contract ContractMaker {

	address Administrator;
	bool HaveIMadeAContractYet = false;
	
	constructor(){
		creator = msg.sender;
	}
	
	DispenserTypeContract public DTC;
	DataStorageTypeContract public DSC;
	DepositTypeContract public DPC;
	UserEndContract public UserSideContract;
	
	mapping (address => uint) public ContractNumber;
	mapping (address => mapping(string => mapping(uint => DispenserTypeContract))) public DespenserContract;
	mapping (address => mapping(string => mapping(uint => DataStorageTypeContract))) public DataStorageContract;
	mapping (address => mapping(string => mapping(uint => UserSideContract))) public DepositContract; 
	
	struct CommandList {
	}
	
	CommandList public Commands;
	
	struct ContractModData {
		string _TypeOfContract;
		uint _AmountOfModifications;
		uint _MaximumOverDrawWarning;
		uint _ModificationTimeStamp;
		uint _FailedModifications;
		event _ErrorCode(string Error);
	}
	
	mapping (address => mapping(string => mapping(uint => ContractModData))) public ContractModificationData; 
	
	function CreateContracts (string ContractType, string memory ContractName) public {
		require(msg.sender == Administrator, "You do not have permissions to this smart contract.");
		require(ContractType == "DispenserContract" || ContractType == "dispensercontract" || ContractType == "DataContract" || ContractType == "datacontract" || ContractType == "DepositContract" || ContractType == "depositcontract", "Invalid configuration.");
		if(ContractType == "DispenserContract" || ContractType == "dispensercontract") {
			ContractNumber[msg.sender] += 1;
			DespenserContract[msg.sender][ContractName][ContractNumber[msg.sender]] = DTC = new DispenserTypeContract();
			HaveIMadeAContractYet = true;
			ContractModificationData[msg.sender][ContractNumber[msg.sender]][ContractName] = ("Dispenser", 0, 0);
		} else if (ContractType == "DataContract" || ContractType == "datacontract") {
		        ContractNumber[msg.sender] += 1;
		        DataStorageContract[msg.sender][ContractName][ContractNumber[msg.sender]] = DSC = new DataStorageTypeContract();
			HaveIMadeAContractYet = true;
			ContractModificationData[msg.sender][ContractNumber[msg.sender]][ContractName] = ("Dispenser", 0, 0);
		} else if (ContractType == "DepostContract" || ContractType == "depositcontract") {
			ContractNumber[msg.sender] += 1;
			DepositContract[msg.sender][ContractName][ContractNumber[msg.sender]] = DPC = new DepositTypeContract();
			HaveIMadeAContractYet = true;
			ContractModificationData[msg.sender][ContractNumber[msg.sender]][ContractName] = ("Dispenser", 0, 0);
		}
	}	
	
	function AdminControllPanel(string ContractType, string contractname , uint ContractNumber, uint ModificationNumber1) public {
		require(msg.sender == Administrator, "You do not have permissions to this smart contract.");
		if(ContractType == "DispenserContract" || ContractType == "dispensercontract"){
		} else if (ContractType == "DataContract" || ContractType == "datacontract") {
		} else if (ContractType == "DepostContract" || ContractType == "depositcontract") {
		//Can only alter current contract data.
			try DataStorageTypeContract.ContractConfiguration(MaximumOverdrawWarnings){
				ContractModificationData[msg.sender][ContractName][ContractNumber[msg.sender]]._TypeOfContract = "Deposit Type Contract";
				ContractModificationData[msg.sender][ContractName][ContractNumber[msg.sender]]._AmountOfModifications += 1;
				contractModificationData[msg.sender][ContractName][ContractNumber[msg.sender]]._MaximumOverDrawWarning = ModificationNumber1;
				contractModificationData[msg.sender][ContractName][ContractNumber[msg.sender]]._ModificationTimeStamp = block.timestamp;
			} catch (string memory ErrorCode) {
			 	emit contractModificationData[msg.sender][ContractName][ContractNumber[msg.sender]]._ErrorCode(ErrorCode);
			 	contractModificationData[msg.sender][ContractName][ContractNumber[msg.sender]]._FailedModifications += 1;
			}
		}
	}
	
}
