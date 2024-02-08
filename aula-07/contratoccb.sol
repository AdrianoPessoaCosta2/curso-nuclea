
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

import "./titulo.sol";
import "./owner.sol";

contract CCB is Titulo, Owner {

       /**
       * @dev
       */
    struct CCBData {
        string devedor;
        address credor;
        uint256 valor;
        uint256 dataEmissao;
        uint256 prazoVencimento;
        bool liquidada;
    }
    /**
     * @dev Mapeamento para armazenar as CCBs emitidas
    */
    CCBData public ccbPorId;

    /**
     * @dev Evento emitido quando uma nova CCB é emitida
     */
    event CCBEmitida(uint256 id, string devedor, address credor, uint256 valor, uint256 prazoVencimento);

       /**
     * @dev Função para emitir uma nova CCB

     * @dev Verificar se o ID da CCB já está em uso
     */
    function emitirCCB(uint256 _id, string memory _devedor, address _credor, uint256 _valor, uint256 _prazoVencimento) public {
      
        ccbPorId.devedor = _devedor;
        ccbPorId.credor = _credor;
        ccbPorId.valor = _valor;
        ccbPorId.prazoVencimento = _prazoVencimento;
        ccbPorId.dataEmissao = block.timestamp;
        ccbPorId.liquidada = false;

        /**
        * @dev
        */
        emit CCBEmitida(_id, _devedor, _credor, _valor, _prazoVencimento);
        
    }
     /**
     * @dev
     */
    function liquidarCCB() public onlyOwner {
        // Verificar se a CCB existe e não está liquidada
        require(!ccbPorId.liquidada, "CCB ja liquidada");

       /**
       * @dev
       */
        ccbPorId.liquidada = true;
    }

        /**
     * @dev Retorna o valor nominal.
     */
    function valorNominal() external view returns (uint256) {
        return ccbPorId.valor;
    }

    /**
     * @dev Retorna o nome do Emissor.
     */
    function nomeEmissor() external view returns (string memory) {
        string memory temp = ccbPorId.devedor;
        return temp;
    }

    /**
     * @dev Retorna a data da emissao.
     */
    function dataEmissao() external view returns (uint256) {
        return ccbPorId.dataEmissao;
    }
}
