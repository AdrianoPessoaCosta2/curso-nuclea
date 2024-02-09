// SPDX-License-Identifier: GPL-3.0
//0x15c1eaa2b335294c6593b51b155ff2a5a8b0c5fa
pragma solidity 0.8.19;

import "./owner.sol";
import "./titulo.sol";

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract DebentureToken is Titulo, Owner, IERC20 {
    string private _emissor;
    uint256 immutable private _dataEmissao;
    uint256 private _valor;
    uint8 immutable private _decimais;
    uint256 private _prazoPagamento;
    uint16 private _fracoes;
    string public rating;

    string private myName;
    string private mySymbol;
    uint256 private myTotalSupply;
    uint256 public decimals;

    mapping (address=>uint256) private balances;
    mapping (address=>mapping (address=>uint256)) private ownerAllowances;

    modifier hasEnoughBalance(address owner, uint amount) {
        uint balance = balances[owner];
        require (balance >= amount, "Insufficient balance");
        _;
    }

    modifier isAllowed(address spender, address tokenOwner, uint amount) {
        require (amount <= ownerAllowances[tokenOwner][spender], "Amount exceeds allowance");
        _;
    }

    modifier tokenAmountValid(uint256 amount) {
        require(amount > 0, "Amount must be greater than zero");
        require(amount <= myTotalSupply, "Amount exceeds total supply");
        _;
    }

    constructor(string memory emissor_) {
        _emissor = emissor_;
        _dataEmissao = block.timestamp;
        _valor = 100000000;
        _decimais = 2;
        _prazoPagamento = _dataEmissao + 90 days;
        rating = "BBB-";
        _fracoes = 1000;
        
        myName = "Token Nuclea Series 01 2024";
        mySymbol = "ADRIANO";
        decimals = 2;
        mint(msg.sender, (1000000000 * (10 ** decimals)));
        emit NovoPrazoPagamento(_dataEmissao, _prazoPagamento);
    }

    function valorNominal() external view returns (uint256) {
        return _valor;
    }

    function nomeEmissor() external view returns (string memory) {
        return _emissor;
    }

    function dataEmissao() external view returns (uint256) {
        return _dataEmissao;
    }

    function mudaRating(string memory novoRating) external onlyOwner returns (bool) {
        rating = novoRating;
        return true;
    }

    function alteraFracoes(uint16 fracoes_) external onlyOwner returns (bool) {
        require(fracoes_ >=100, "Number of fractions too low");
        _fracoes = fracoes_;
        return true;
    }

    function fracoes() external view returns (uint16) {
        return _fracoes;
    }

    function name() public view returns(string memory) {
        return myName;
    }

    function symbol() public view returns(string memory) {
        return mySymbol;
    }

    function totalSupply() public override view returns(uint256) {
        return myTotalSupply;
    }

    function balanceOf(address tokenOwner) public override view returns(uint256) {
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public override view returns(uint256) {
        return ownerAllowances[tokenOwner][spender];
    }

    function transfer(address to, uint256 amount) public override hasEnoughBalance(msg.sender, amount) tokenAmountValid(amount) returns(bool) {
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    } 

    function approve(address spender, uint limit) public override returns(bool) {
        ownerAllowances[msg.sender][spender] = limit;
        emit Approval(msg.sender, spender, limit);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public override 
    hasEnoughBalance(from, amount) isAllowed(msg.sender, from, amount) tokenAmountValid(amount)
    returns(bool) {
        balances[from] -= amount;
        balances[to] += amount;
        ownerAllowances[from][msg.sender] -= amount;
        emit Transfer(from, to, amount);
        return true;
    }
    
    function mint(address account, uint256 amount) public onlyOwner returns (bool) {
        require(account != address(0), "Mint to the zero address");

        myTotalSupply += amount;
        balances[account] += amount;
        emit Transfer(address(0), account, amount);
        return true;
    }

    function burn(address account, uint256 amount) public onlyOwner returns (bool) {
        require(account != address(0), "Burn from the zero address");
        
        balances[account] -= amount;
        myTotalSupply -= amount;
        emit Transfer(account, address(0), amount);
        return true;
    }
}
