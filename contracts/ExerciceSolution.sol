pragma solidity >=0.6.0 <0.8.0;

import "./IExerciceSolution.sol";
import "./ERC20Claimable.sol";
import "./Evaluator.sol";
import "./ExerciceSolutionToken.sol";

contract ExerciceSolution is IExerciceSolution{

    address public owner;
    mapping(address => uint256) public balance;
    ERC20Claimable claimableERC20;
    Evaluator evaluator;
    ExerciceSolutionToken ecst;

    constructor(Evaluator eval, ERC20Claimable claimableERC20Address) public {
        owner = msg.sender;
        evaluator = eval;
        claimableERC20 = claimableERC20Address;
    }

    function claimTokensOnBehalf() external override{
        uint256 claimedTokens = claimableERC20.claimTokens();
		balance[msg.sender] += claimedTokens;

    }

	function tokensInCustody(address callerAddress) external override returns (uint256){
        return balance[callerAddress];
    }

	function withdrawTokens(uint256 amountToWithdraw) external override returns (uint256)
	{
        ExerciceSolutionToken ecstAddress = ExerciceSolutionToken(address(ecst));
        require(ecstAddress.balanceOf(msg.sender) >= amountToWithdraw, "Not enough tokens in custody");
		claimableERC20.transferFrom(address(this), msg.sender, amountToWithdraw);
        ecstAddress.burn(msg.sender,amountToWithdraw);
        return ecstAddress.balanceOf(msg.sender);
	}

	function getERC20DepositAddress() external override returns (address){
        return address(ecst);
    }

    function depositTokens(uint256 amountToWithdraw) external override returns (uint256){
        claimableERC20.transferFrom(msg.sender, address(this), amountToWithdraw);
        ExerciceSolutionToken ecstAddress = ExerciceSolutionToken(address(ecst));
        ecstAddress.mint(msg.sender, amountToWithdraw);
        return ecstAddress.balanceOf(msg.sender);
    }
    function setExerciceSolutionToken(ExerciceSolutionToken ecstAddress) public{
        require(msg.sender == owner, "Only owner can set ERC20 token");
        ecst = ecstAddress;
    }

    fallback () external payable 
	{}

	receive () external payable 
	{}


}