// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@solvprotocol/erc-3525/ERC3525.sol";
import "./polygon-id/lib/GenesisUtils.sol";
import "./polygon-id/interfaces/ICircuitValidator.sol";
import "./polygon-id/verifiers/ZKPVerifier.sol";

contract ERC3525GettingStarted is ERC3525, ZKPVerifier {
    using Strings for uint256;
    address public ownerAddr;

    // 登録事業者の一覧
    mapping(address => uint256) private registered;

    // 認証済ユーザの一覧
    mapping(address => uint256) private verified;

    // wardの一覧
    string [] private ward =
    ['Chiyoda', 'Chuo', 'Minato', 'Shinjuku', 'Bunkyo',
    'Taito', 'Sumida', 'Koto', 'Shinagawa', 'Meguro',
    'Ota', 'Setagaya', 'Shibuya', 'Nakano', 'Suginami',
    'Toshima', 'Kita', 'Arakawa', 'Itabashi', 'Nerima',
    'Adachi', 'Katsushika', 'Edogawa'];

    // polygon-idに必要なセットアップ
    mapping(uint256 => address) public idToAddress;
    mapping(address => uint256) public addressToId;

    constructor(
        address owner_
    ) ERC3525("ERC3525GettingStarted", "YEN", 18) {
        ownerAddr = owner_;
    }

    function verifyBackdoor(uint256 slot_) external { // debug用 正式版リリース時消す
        verified[msg.sender] = slot_;
    }

    function register(uint256 slot_) external {
        require(
            registered[msg.sender] == 0, // uintの初期値は0 なので、0の場合は未登録と判断
            "ERC3525GettingStarted: already registered"
        );
        registered[msg.sender] = slot_;
    }

    function exists(uint256 tokenId_) external view returns (bool exists_) {
        return _exists(tokenId_);
    }

    function mint(address to_, uint256 slot_, uint256 amount_) external {
        require(
            msg.sender == ownerAddr,
            "ERC3525GettingStarted: only owner can mint"
        );
        // to_が認証済であることを確認
        require(
            verified[to_] == slot_,
            "ERC3525GettingStarted: only verified user can mint"
        );
        _mint(to_, slot_, amount_);
    }

    function tokenURI(
        uint256 tokenId_
    ) public view virtual override returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<svg width="600" height="600" xmlns="http://www.w3.org/2000/svg">',
                    " <g> <title>Layer 1</title>",
                    '  <rect id="svg_1" height="600" width="600" y="0" x="0" stroke="#000" fill="#000000"/>',
                    '  <text xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="24" id="svg_2" y="270" x="200" stroke-width="0" stroke="#000" fill="#ffffff">tokenID: ',
                    tokenId_.toString(),
                    "</text>",
                    '  <text xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="12" id="svg_2" y="410" x="200" stroke-width="0" stroke="#000" fill="#ffffff">owner: ',
                    Strings.toHexString(uint256(uint160(ownerOf(tokenId_))), 20), // addressを16進数に変換
                    "</text>",
                    '  <text xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="24" id="svg_3" y="340" x="200" stroke-width="0" stroke="#000" fill="#ffffff">Balance: ',
                    balanceOf(tokenId_).toString(), ' YEN'
                    "</text>",
                    '  <text xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="24" id="svg_3" y="200" x="200" stroke-width="0" stroke="#000" fill="#ffffff">Slot: ',
                    ward[slotOf(tokenId_) - 1], // slot は23区を表す
                    "</text>",
                    '  <text xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="24" id="svg_4" y="160" x="150" stroke-width="0" stroke="#000" fill="#ffffff">ERC3525 GETTING STARTED</text>',
                    " </g> </svg>"
                )
            );
    }

    function transfer(
        address to_,
        uint256 tokenId_
    ) external payable {
        // to が登録済であることを確認
        require(
            registered[to_] == slotOf(tokenId_),
            "ERC3525GettingStarted: transfer to unregistered recipient"
        );
        transferFrom(ownerOf(tokenId_), to_, tokenId_);
    }

    // function _beforeProofSubmit(
    //     uint64, /* requestId */
    //     uint256[] memory inputs,
    //     ICircuitValidator validator
    // ) internal view override {
    //     // check that the challenge input of the proof is equal to the msg.sender
    //     address addr = GenesisUtils.int256ToAddress(
    //         inputs[validator.getChallengeInputIndex()]
    //     );
    //     require(
    //         _msgSender() == addr,
    //         "address in the proof is not a sender address"
    //     );
    // }

    function _afterProofSubmit(
        uint64 requestId,
        uint256[] memory inputs,
        ICircuitValidator validator
    ) internal override {
        require(
            addressToId[_msgSender()] == 0,
            "proof can not be submitted more than once"
        );

        require(
            proofs[_msgSender()][requestId] == true,
            "only identities who provided proof are allowed to receive verification"
        );

        uint256 id = inputs[validator.getChallengeInputIndex()];
        // 認証を与える
        if (idToAddress[id] == address(0)) {
            verified[_msgSender()] = requestId; // 認証を与える. requestId は slot に対応させている
            _mint(_msgSender(), requestId, 500);    // 500円分mint(airdrop)を行う
            addressToId[_msgSender()] = id;
            idToAddress[id] = _msgSender();
        }
    }

    // function _beforeValueTransfer(
    //     address ,
    //     address to_,
    //     uint256 ,
    //     uint256 ,
    //     uint256 ,
    //     uint256
    // ) internal view override {
    //     require(
    //         proofs[to_][TRANSFER_REQUEST_ID] == true,
    //         "only identities who provided proof are allowed to receive tokens"
    //     );
    // }
}
