// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@solvprotocol/erc-3525/ERC3525.sol";

contract ERC3525GettingStarted is ERC3525 {
    using Strings for uint256;
    address public owner;

    // 登録事業者の一覧
    mapping(address => bool) private registered;

    // prefの一覧
    string [] private pref =
    ['Hokkaido','Aomori','Iwate','Miyagi','Akita',
    'Yamagata','Fukushima','Ibaraki','Tochigi','Gunma',
    'Saitama','Chiba','Tokyo','Kanagawa','Niigata',
    'Toyama','Ishikawa','Fukui','Yamanashi','Nagano',
    'Gifu','Shizuoka','Aichi','Mie','Shiga',
    'Kyoto','Osaka','Hyogo','Nara','Wakayama',
    'Tottori','Shimane','Okayama','Hiroshima','Yamaguchi',
    'Tokushima','Kagawa','Ehime','Kochi','Fukuoka',
    'Saga','Nagasaki','Kumamoto','Oita','Miyazaki',
    'Kagoshima','Okinawa'];

    // [unicode"北海道",unicode"青森県",unicode"岩手県",unicode"宮城県",unicode"秋田県",
    // unicode"山形県",unicode"福島県",unicode"茨城県",unicode"栃木県",unicode"群馬県",
    // unicode"埼玉県",unicode"千葉県",unicode"東京都",unicode"神奈川県",unicode"新潟県",
    // unicode"富山県",unicode"石川県",unicode"福井県",unicode"山梨県",unicode"長野県",
    // unicode"岐阜県",unicode"静岡県",unicode"愛知県",unicode"三重県",unicode"滋賀県",
    // unicode"京都府",unicode"大阪府",unicode"兵庫県",unicode"奈良県",unicode"和歌山県",
    // unicode"鳥取県",unicode"島根県",unicode"岡山県",unicode"広島県",unicode"山口県",
    // unicode"徳島県",unicode"香川県",unicode"愛媛県",unicode"高知県",unicode"福岡県",
    // unicode"佐賀県",unicode"長崎県",unicode"熊本県",unicode"大分県",unicode"宮崎県",
    // unicode"鹿児島県",unicode"沖縄県"];

    constructor(
        address owner_
    ) ERC3525("ERC3525GettingStarted", "YEN", 18) {
        owner = owner_;
    }

    function register() external {
        require(
            !registered[msg.sender],
            "ERC3525GettingStarted: already registered"
        );
        registered[msg.sender] = true;
    }

    function exists(uint256 tokenId_) external view returns (bool exists_) {
        return _exists(tokenId_);
    }

    function mint(address to_, uint256 slot_, uint256 amount_) external {
        require(
            msg.sender == owner,
            "ERC3525GettingStarted: only owner can mint"
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
                    '  <text xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="24" id="svg_2" y="340" x="200" stroke-width="0" stroke="#000" fill="#ffffff">tokenID: ',
                    tokenId_.toString(),
                    "</text>",
                    '  <text xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="24" id="svg_3" y="410" x="200" stroke-width="0" stroke="#000" fill="#ffffff">Balance: ',
                    balanceOf(tokenId_).toString(),
                    "</text>",
                    '  <text xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="24" id="svg_3" y="270" x="200" stroke-width="0" stroke="#000" fill="#ffffff">Slot: ',
                    pref[slotOf(tokenId_) - 1], // slot は都道府県を表す
                    "</text>",
                    '  <text xml:space="preserve" text-anchor="start" font-family="Noto Sans JP" font-size="24" id="svg_4" y="160" x="150" stroke-width="0" stroke="#000" fill="#ffffff">ERC3525 GETTING STARTED</text>',
                    " </g> </svg>"
                )
            );
    }

    function transfer(
        address from_,
        address to_,
        uint256 tokenId_
    ) external payable {
        // from_ がオペレーターかトークンの所有者であることの確認は重複するため不要
        // require(
        //     from_ == ownerOf(tokenId_) | msg.sender == owner,
        //     "ERC3525GettingStarted: transfer of token that is not owned"
        // );
        // to が登録済であることを確認
        require(
            registered[to_], // TODO: 都道府県ごとにチェックが入るべき
            "ERC3525GettingStarted: transfer to unregistered recipient"
        );
        transferFrom(from_, to_, tokenId_);
    }
}
