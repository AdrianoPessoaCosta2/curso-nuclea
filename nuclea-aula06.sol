
/*
SPDX-License-Identifier: CC-BY-4.0
(c) Desenvolvido por Adriano Costa
This work is licensed under a Creative Commons Attribution 4.0 International License.
*/
pragma solidity 0.8.19;

/// @author Adriano Costa
/// @title Um exemplo de Faucet
contract Distribuidor {
    mapping(address => uint256) public atribuicoes;
    mapping(address => uint256) public ultimaAtribuicao;
    uint256 public valorBase;

    // Eventos para notificar quando um valor é atribuído e quando o valor base é alterado
    event ValorAtribuido(address indexed destinatario, uint256 valor);
    event ValorBaseAlterado(uint256 novoValor);

    constructor(uint256 _valorBase) {
        valorBase = _valorBase;
    }

    // @notice Atribui um valor multiplicado ao destinatário
    // @dev Incrementa um no contador e atribui o valor resultante ao endereço Ethereum fornecido.
    // @return O valor atribuído
    function atribuirValor() public returns (uint256) {
        require(atribuicoes[msg.sender] == 0, "Desculpe, voce ja recebeu uma atribuicao.");

        uint256 valorAtribuido = valorBase * (ultimaAtribuicao[msg.sender] + 1);
        atribuicoes[msg.sender] = valorAtribuido;
        ultimaAtribuicao[msg.sender]++;
        
        emit ValorAtribuido(msg.sender, valorAtribuido);
        
        return valorAtribuido;
    }

    // @notice Permite ao proprietário do contrato alterar o valor base
    // @dev Define um novo valor base para futuras atribuições
    // @param novoValor O novo valor base
    function alterarValorBase(uint256 novoValor) public {
        valorBase = novoValor;
        emit ValorBaseAlterado(novoValor);
    }

}
