// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./Ownable.sol";
import "./ERC721Enumerable.sol";
import "./OperatorFilterer.sol";
import "./ERC2981.sol";
contract Flares is ERC721, ERC721Enumerable, Ownable, OperatorFilterer, ERC2981 {

    string private _baseURIextended;
    mapping (uint => string) public idToInscription;
    uint256 public constant MAX_SUPPLY = 134;
 
    string public constant baseExtension = ".json";

    constructor() ERC721("FLARES", "Flare") {
        idToInscription[0] = "cc1759d92079e3e59f4fe3312c7d1f082f5c5130a46b876f6a7c13d975ee6e1ai0";
        idToInscription[1] = "d5046894fe27ae68fbb366acab502a365382640391780584f3acc46c31477f25i0";
        idToInscription[2] = "cdf2cd1dac4558fc982451e0b53b489405b672b473d062191bb9998402f30126i0";
        idToInscription[3] = "e50fe104230de81db1966b13ba93922450503f172377fa5ee79d7c5305159d63i0";
        idToInscription[4] = "11ea81b136205822f23a4b960b5e5e83575d5f76a51653f8569569ec412c038ai0";
        idToInscription[5] = "8baba2ac593203dc19e0de910a14d032f263747fb82c97fb09c6e75b7776909ai0";
        idToInscription[6] = "8a24a11d802db0003be00d83ffe680ee99d62a40f768c433042fa1d9b978cfa6i0";
        idToInscription[7] = "3a6606a2aa83970a0f1997bfc7052af969f12c2dd510ddae6ba718b1e96157fei0";
        idToInscription[8] = "e9e24328a1be0faa9ddb9f680bc56272c2c6e29ce054b628089092b841c017cci0";
        idToInscription[9] = "f28e6d75b4286033fb8e2bf911343cc5eaa523fd288f4958adc85bc88f67ad79i0";
        idToInscription[10] = "614d415daeec6177fc9d8de27f09355d55503060c6cacd66309dd099fd39bf9ai0";
        idToInscription[11] = "cdc35b7c536cdf1bdb47f8e5c7b4c53162845afad6440c0598c6eea3567758dci0";
        idToInscription[12] = "cb88317d2a3c2cf93374ae118c3e3c14d3d0d0d5c63decca2ad0d9f6004d9284i0";
        idToInscription[13] = "939341fa3bc1fb7711867ff0e0cef5c0112b52d2aef9885e77e5da41ed23bb88i0";
        idToInscription[14] = "02481846c2c4d08af622f3b7e507f21329bd06f18ce0772b91907b17e8a74127i0";
        idToInscription[15] = "907182d3ae0aef9a3a9eb31c6c025415b94e7dbd78a0824f3739e06e6222cfd6i0";
        idToInscription[16] = "0bff192351499bda25d391bad83572e9226de1686b411e57f4d38d12250f54abi0";
        idToInscription[17] = "3d3a89198795d9984ff72659b47d6cf8c6f26c27c8c95ec551855f3bc08a0071i0";
        idToInscription[18] = "175ab166a5e5f2855d8027474e32a908a7431ba6df7ed4b38352aa054f205dafi0";
        idToInscription[19] = "df04d65a93cd76541310e7f154f85d930f96f8ca7aab802dd30f19045ed493aci0";
        idToInscription[20] = "b34624fa26c5e36dc89eda28d36ac3af98c361045b0c87ced3ae54786a047fbai0";
        idToInscription[21] = "6554061d9b7c4f7a8fba39e5621108d2d4467a237904694425503a164fd86acei0";
        idToInscription[22] = "a72d5c68006d842e14b196cf338490292d6a63f1337c465bf8200f2edbc3192di0";
        idToInscription[23] = "aa2e8db1e521cafdc11b6f29fca5df6ea535c28f0bceb84f541ac666cd0a7c34i0";
        idToInscription[24] = "829f74071b73921f1b0f34fc6ed26a2e2c60c07b0802ab9ed45ae3323655863ci0";
        idToInscription[25] = "27b925f24ac8e2b886055ec01e341205f143b0014b1fca75c450b29146efad61i0";
        idToInscription[26] = "987b1fdbb2e0a2d874aedf61a289fd23bf80607fb8343dbdd29c1fa260cd02c5i0";
        idToInscription[27] = "fd2738314796197b7368133c0821d812cf47325378a4301620786fb45afa3ec9i0";
        idToInscription[28] = "aa2d19e8a3d8f0b0615129daa4d30df6163ae06d0e905394d9d6d489185f58d6i0";
        idToInscription[29] = "53aa1db4c875a39896d8fdb48ae1170bc58c4b7896f67f423f709b8d1fafa460i0";
        idToInscription[30] = "53e3b452edaeb6a6f866b011c1d482faee4cee66e64df2b7b6c7a94f5bd95590i0";
        idToInscription[31] = "3842cfb0e60bcd1f60ab0e0f654cc41cd1cd4c865bdd888a1ba8dba9b054fd12i0";
        idToInscription[32] = "b960b8962d2db39f0105b4bbf4f81b3073615dffa427e784472e8cd24666c346i0";
        idToInscription[33] = "8ae688bc3216f605fb6b32eed15104923fc3036b20cf1ac3cfb28b4841d96b53i0";
        idToInscription[34] = "878a1f4e9723bb46bed7b65c204e186f5d32df37d700a08c1bb5acc3aec9317ci0";
        idToInscription[35] = "ee6533c1a2344b2008876b43eeb1fb95ee8058c5e7ed86e5636aa92815892c94i0";
        idToInscription[36] = "967dfd73b1208717f255c1a20d36c0db4b7c16dfecc91c1beb9a2e5c4f13a3cci0";
        idToInscription[37] = "c19c850fe8f6b006d485deb745285ad4b2db4689f207d18574a69544c4091634i0";
        idToInscription[38] = "5bef9875f3ad7041614515f7d53727434831c37424ab1072c58e682be42e274ei0";
        idToInscription[39] = "186e582598fed3a5afc2463717dacb27d9a8f4c46d1c2e9d9a0c1a7f6896c78fi0";
        idToInscription[40] = "cfd4d73dca7d42652076427c6ce16b771a2a181e32d740445f915024001d3feci0";
        idToInscription[41] = "6fb789edc911093de20717109ef778abf91a7a064d66c353ff0a121b3a4bd4c4i0";
        idToInscription[42] = "7a36cb6a0cbc4d5b93da50c24e8107c66cce55fae75c3650f467985244e84382i0";
        idToInscription[43] = "8be4defbc5f896986da74269e55e1550b20bc718203770b92f12147796eb8676i0";
        idToInscription[44] = "48e3083f1ecf8807d5fad7b0771965ed66e9f99e3e798f5259d700887730d4c6i0";
        idToInscription[45] = "82ddd95e065f2c4b5dc9ec1ec535492697015d9aeecdd9dd096ce37dd36605d3i0";
        idToInscription[46] = "685154c1fd44082afe285bc44c974d4cd58da6e36d166b071120ac6434d6347di0";
        idToInscription[47] = "e0be08eb6fed6ec19a2f0f227f72280eac01dce80b8e780113c14dae0619f9e6i0";
        idToInscription[48] = "de19cef2d44124ca0baded70d3f6e24e46b2bf45a848e4122b66360ee26cb0b9i0";
        idToInscription[49] = "b0ed872240292bcda52f013e669adcc9fa48ba428f0b4a8bca14c76c6470a398i0";
        idToInscription[50] = "716091e8e49845f2c5a816000312719de587e36712b3fd171282f5a021ea220ci0";
        idToInscription[51] = "eda797e3cf92e3bb8159ed7f5415cdb520eaad0ee0fe6426cb13a7b77cf4152ei0";
        idToInscription[52] = "5406f9838fa14252d4c5c289e28f6434f2fe89a53aead78654133d45918b5779i0";
        idToInscription[53] = "50a4657d938ca633ee1f04d19b4f66cf15c990c2f1272cd8cb7d1fca708dba2ei0";
        idToInscription[54] = "0520362c054fde5d33ece18c87d3edfa71aaebeda78fba585c2bff95cf706a4ai0";
        idToInscription[55] = "54220acdbca3e3116a6de7f7092182376f771d33df6eaf27e3470b10c907684fi0";
        idToInscription[56] = "d48dd916f8690d41b6ca5d3ff55705eeb25ee3738803dba0b9a1c6a71f6aed58i0";
        idToInscription[57] = "eea06f5eeb507ece70891277bb5cf84c888d121942931d5f65287d05d5abf9a2i0";
        idToInscription[58] = "bfc1c55e26eeda8e987fbdda88f258d4841aeda2da84dfb43b5656365f3b6fd2i0";
        idToInscription[59] = "069674a9baab5b3d98ac9a965e15ce0e334c7f185a8363407eb4cbeb9693b9b9i0";
        idToInscription[60] = "2035d0511bca901b539a353a5135bce6583154335231aaba00718855592a6a0bi0";
        idToInscription[61] = "ce5d974efd81ad0ddcab996ae295f823f1f8ad0a68a1d4d458fa4039fa655288i0";
        idToInscription[62] = "bd63cf785227de53161bb9ae68a1711f5278bb9382a11170e0fa22516898c675i0";
        idToInscription[63] = "703d18525eb23e867bb32e600ac9b8cb7e15d788e016f688ed1bbb5638dbab28i0";
        idToInscription[64] = "93ab0cb05b301f9ad0b1e5e19af560a49a62bce8931b4b6d18cb537e7e7bc957i0";
        idToInscription[65] = "bba6d1694fce36460c592540adabd7b741a22cd937576a80b4e058a88eea4730i0";
        idToInscription[66] = "37f2e51403ad43388ec409e68308887116a4b5bd565dfc16633fbb7fd41fac04i0";
        idToInscription[67] = "a09ff3b46d80566b011d3b480321469534a1b7263c63c9f22f80d46ba814bf19i0";
        idToInscription[68] = "184d62e22b414cc76acc64dda96d2d8a4dce6d8dfe91bce8ec1754862be9f194i0";
        idToInscription[69] = "488eb106abcccd7af8ffcb3930de1399cffcc67ed2cd98a342c08e3eca389f19i0";
        idToInscription[70] = "c835c3a5727546800490e735d314ee47f3300ae59efc2ceb9e2f8f0cdcb85624i0";
        idToInscription[71] = "47b791e5ab5a57f7fec68d913516c0b36358f451f63ed7d4128cd3a0c691ae2di0";
        idToInscription[72] = "6691350d6ffca0165a33cb9796a9f730f45da768f2f0e158840a1d9a31c08643i0";
        idToInscription[73] = "ff37a0f5e5a3b973cea9abe7e6195377d9c5b033be8a40a71974684ba1ac5451i0";
        idToInscription[74] = "6cf4357f4bded0c9b0367df68552d4b8f59a45a6d7f72df3cb53d099a9eab851i0";
        idToInscription[75] = "3b81e68d2543d0cecca2ce9e834e7bf9d75bfefebbc0f81c55c9f2cfa155ae61i0";
        idToInscription[76] = "5bffc7f9f04addf793f477f525cc16873ffa3d6591a7c64dbbf5f55fdc1d556bi0";
        idToInscription[77] = "49ed841f13a8ad720eb67f7590a9c956f403ddc6fce484d56580411108197687i0";
        idToInscription[78] = "7b27bbcf4e5b98922e41f59f35539da141c6afd57a8ea62b64bdf0aff3179488i0";
        idToInscription[79] = "97b00b878bf9b6414c6622f38e633903a470d8977ba11c9c470d29d650c36492i0";
        idToInscription[80] = "3e5293b28cece20e06d4a7170a35a624473569793d5cd2440c050559392fcf93i0";
        idToInscription[81] = "9e6f80d406ed8ee9690af4214fde1c18f37f6ab76f80c80116bea1cd77757a97i0";
        idToInscription[82] = "699a948649020f71c616dd9f98a8426b4f05b7395600fba26f7bac7d0962d5a3i0";
        idToInscription[83] = "beddaebd6ad14babd1c5fab7d1c3f38d045db8e751989e55d50aa91eded564aci0";
        idToInscription[84] = "d95309413bf22d4cf93a41a83d0f302273422cb837d659abf9f5c5aabb1b44b2i0";
        idToInscription[85] = "83b8e77c5d760f32e479ac2e09c7b55d3ce6cb380ac640d788d98c9779f04ceai0";
        idToInscription[86] = "b450c784dbcd40e02576cc23217c6663ac495b5409f9b30af04efdcd625d7e9ai0";
        idToInscription[87] = "1498980472d6dd4f05d40245d56e07e4b4f6e4de14d62b94bd5f34883a646725i0";
        idToInscription[88] = "5d581cfc0bde25b6ce61a4d5de22231757ac49cee9c90f15182caa06347afc50i0";
        idToInscription[89] = "302e06189b93f2a4cc683909e4d2139cbe67d10fce1020243a1ac52aa9bb2c64i0";
        idToInscription[90] = "0b0f3b582927d0c4769e848dcace31b7566f3529ee645ee7546446c70a3c5333i0";
        idToInscription[91] = "5a0237b52e7ff168d18762057992f07a434bbf79809c6fbfa0d7606f19414f0ai0";
        idToInscription[92] = "b7f1c0fa2928ea617c4f1783e00f410b48f0ab08e661d8aa555d144c0307fde2i0";
        idToInscription[93] = "d2069d831d96a7c23f9419c5ac75a3cf73e2b72cba335e570dd25205d239e0bbi0";
        idToInscription[94] = "18414666897fda777c1646111aae1c00e91dceb91da55d2674c406fee503f915i0";
        idToInscription[95] = "1eabf507f7e961d892dc9f586990f73e01d13bcff456015c87e883ce62c03ff2i0";
        idToInscription[96] = "e517043d67d6b5bb42d7465c75d88be64de1dcaae444f47a3d0b03cc534b1b40i0";
        idToInscription[97] = "77367fb418051ac8e98d4c0b37e0565d5287dd6d71d8a414c4f05700153621d0i0";
        idToInscription[98] = "3ccefedbf405c56bcf76718fc285c1f56b2293157eaf90f0c626569697f19818i0";
        idToInscription[99] = "265478351bb23998b42897d1ce9e25dfc7c8412790f80f13d946b90295963ff3i0";
        idToInscription[100] = "365a7ae41e5d994224f78e73454e4d82b0629880f2586e758c684548e6023302i0";
        idToInscription[101] = "ed402d4401b270aec979fc9ca5dc8e98f52b2001f903b15a9ed09b6c3b9d5d6fi0";
        idToInscription[102] = "2975e1406cc815acd4974e91dc757be4e4847226715586012e7915e37c2817bai0";
        idToInscription[103] = "37a72c7e3c3a0c9c9f3abeddf0d0c092796caf5c0ad4d1cbd8a3af9156bfe0ddi0";
        idToInscription[104] = "101605db8f686004bc4a2ce9f3c85c8425485c6d090c5c87e9e51b261968b6e7i0";
        idToInscription[105] = "c281331168558e48de6ebd591d1ad2775b0f379134b0421c5cd26c6246cac1eei0";
        idToInscription[106] = "b1bb829daee40494ecad58574fd04199295b29d6a04dcf422352b852120bf2ffi0";
        idToInscription[107] = "853b836fc57c6553729fd45675ba50e140d75bedd76e0f1976818627503b361fi0";
        idToInscription[108] = "304abef21655ba54d49482a73ff2d47a34ebe0a085dfbf648792099ce9a5fe1ci0";
        idToInscription[109] = "b7f5b32b7e55c5ef49ddcf1ddc81e84cf95289beaa1ba8eb343a02b1da73ab59i0";
        idToInscription[110] = "582178192b5114b11801e4acd0c5f76998f67ec7c38824c9378dd8ed8a0bf833i0";
        idToInscription[111] = "7d3b2268c66fef6cfe5ac60dc4d664df98b0ab0c02007f6f12add4bfea6440f5i0";
        idToInscription[112] = "68abcc60a14370f0e7e04a6ab1d1f5643d47e9313a156118793a628ab5af0cb4i0";
        idToInscription[113] = "34f9d236ecbe81534e064515763c38285596dcf00d07480cd451856dffe2fba6i0";
        idToInscription[114] = "9c3a5719dfdd8d299a2936347d8a42a47576e4809a51e6c94f75500d5ca693c7i0";
        idToInscription[115] = "9ccb0eadbab9a32ac4bf751c0ae15264d7d6ceb3286a5cd8bcfaffbc7f46d46ci0";
        idToInscription[116] = "bb7e23cf972655ba4d59e66ea075bce9081bb49774657e833306545a7829bc6fi0";
        idToInscription[117] = "5f45a63fd2d5bdfaa5badb0ff91180f1fde29b38cc1c689fb084031c51879888i0";
        idToInscription[118] = "f453d6acec880991271df617bce58c0d57c0416142b77807c8541ccadc8ad88fi0";
        idToInscription[119] = "19565600e398c5839e5723c8119edcc83cf71e93cca04b654335d3263c6a4d72i0";
        idToInscription[120] = "1824cea64a8c2ed8d8aa283bd56ef1ed0a5b4d2a7d0754ef590021384ba916bbi0";
        idToInscription[121] = "dcb3bc064d069b20520333c43bf0d914031dfc273879b96d7de52915948365f2i0";
        idToInscription[122] = "5a5c3800f1dca727571288a5a7d2cef33fa25ff88026d5139218211128724eb6i0";
        idToInscription[123] = "98283c36af20234aa4d3e2ea021a5f8800dcac6c95113dd07d8b77dcdce08a31i0";
        idToInscription[124] = "5255ece3abec3f334978d22c0c607e1657e4347ccc1978c0b885f0251dd7aa9fi0";
        idToInscription[125] = "8df006b76b5ff4fb909f439e1e64571480c3a1d6a3b48072ddc4e5e37b0939abi0";
        idToInscription[126] = "b5d1ddf17c8affd94e2c05751c32e69c2b2f52c09e589b14705f457d5c743128i0";
        idToInscription[127] = "99d6cc6a1388235f191cf06e05eb4989dced9542172ebd46eec0ef99b779918ci0";
        idToInscription[128] = "89e0921ab50df823e61bd2908e5bf348a7510a45426049732dbafad3241dcb96i0";
        idToInscription[129] = "a379505b6e95b4addfddfe9793159d7c8e5f915ae6d5032c35aefa199eed23ffi0";
        idToInscription[130] = "bf6889715883cd971a924931b2e763389cc803163be88f65f6474182c6ac64a5i0";
        idToInscription[131] = "a243969dae472a437651abbdd3eae0835999281148487c1d2a06c4843be84eaci0";
        idToInscription[132] = "8632b2448e9eada7b130d8f15f103a84bff40a08deba1d620cc727657210527ci0";
        idToInscription[133] = "f81b409991e7559bc5ac4f8fcc343c3aaed268e1615b0c89376ec402b8061426i0";
        _registerForOperatorFiltering();
        operatorFilteringEnabled = true;
        _setDefaultRoyalty(msg.sender, 500);
        _safeMint(msg.sender, 0);
        _baseURIextended = "https://flares.mypinata.cloud/ipfs/QmRbPyCKwVYCPzcLRP8ksM9CUW8VTzaKrJRvYXENAauigY/";
    }
    
    bool public operatorFilteringEnabled;
    
    function setApprovalForAll(address operator, bool approved) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
        super.setApprovalForAll(operator, approved);
    }
    
    function approve(address operator, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperatorApproval(operator) {
        super.approve(operator, tokenId);
    }

    function setDefaultRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
        _setDefaultRoyalty(receiver, feeNumerator);
    }

    function setOperatorFilteringEnabled(bool value) public onlyOwner {
        operatorFilteringEnabled = value;
    }

    function _operatorFilteringEnabled() internal view override returns (bool) {
        return operatorFilteringEnabled;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual returns (bytes4) {
        return this.onERC721Received.selector;
    }
    function transferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from) {
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override(ERC721, IERC721) onlyAllowedOperator(from) {
        super.safeTransferFrom(from, to, tokenId);
    }
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override(ERC721, IERC721) onlyAllowedOperator(from) {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function setBaseURI(string memory baseURI_) external onlyOwner() {
        _baseURIextended = baseURI_;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    function reserve(uint256 n) public onlyOwner {
      uint supply = totalSupply();
      uint i;
      require(MAX_SUPPLY >= supply + n, "exceeds max supply");
      for (i = 0; i < n; i++) {
          _safeMint(msg.sender, supply + i);
      }
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        ); 
        return
            string(
                abi.encodePacked(
                    _baseURIextended,
                    Strings.toString(_tokenId),
                    baseExtension
                )
            );
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}