pragma solidity >=0.6.0 <0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IERC20Mintable.sol";


contract ExerciceSolutionToken is ERC20, IERC20Mintable{

    mapping(address => bool) private _minters;
    address public owner;

    constructor(address solution) public ERC20("ExerciceSolutionToken", "ECST") {
        _minters[msg.sender] = true;
        _minters[solution] = true;
        owner = msg.sender;
    }

    function setMinter(address minterAddress, bool isMinter)  external override {
        require(msg.sender==owner, "Only minter can set minter");
        _minters[minterAddress] = isMinter;
    }

	function mint(address toAddress, uint256 amount) external override {
        require(_minters[msg.sender], "Only minter can mint");
        _mint(toAddress, amount);
    }

	function isMinter(address minterAddress) external override returns (bool){
        return _minters[minterAddress];
    }
    function burn(address user,uint256 amount) external {
        require(_minters[msg.sender], "Only minter can burn");
        _burn(user, amount);
    }
}