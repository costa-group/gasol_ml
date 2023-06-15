// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7 <0.9.0;

////import "./Common/IWhiteList.sol";
//--------------------------------------------
// WHITELIST intterface
//--------------------------------------------
interface IWhiteList {
    //--------------------
    // function
    //--------------------
    function check( address target ) external view returns (bool);
}

//------------------------------------------
// wl_PUBLIC_03
//------------------------------------------
contract wl_PUBLIC_03 is IWhiteList {
    //---------------------------
    // storage
    //---------------------------
    mapping( address => bool) private _address_map;

    //-----------------------------------------
    // コンストラクタ
    //-----------------------------------------
    constructor(){
_address_map[0x6740d33927f5FD898Ba5256004D9e02efbc8926F] = true;
_address_map[0x6742e83aa12B137B03565931a7b120dD7A5C0f02] = true;
_address_map[0x67433E47da77D5b8cAA099C251bE6ee47095fF74] = true;
_address_map[0x674A937450f43Bc148c51A5AA73E03D8D18bDf30] = true;
_address_map[0x679387fD09fe35A7c7b7B6EcBaa5E42065233B2A] = true;
_address_map[0x67965e0163E9c50Fd660789735aCcc162C183477] = true;
_address_map[0x67cda4fAbA496FAE55DD226cdA5c835209740262] = true;
_address_map[0x67D42167518dDfADbe3d2f40Ea1b9c43b2893251] = true;
_address_map[0x67E86c6B1d99eb9654C06eAb3CE3Cf66E8755c54] = true;
_address_map[0x682CD5f039c276b6b9a2ffB40E6B2d88dbAe324F] = true;
_address_map[0x683b834F61dE58c9D7b640DE542CBb9bf3D0ab41] = true;
_address_map[0x6861DdF639F8AFd31ff0C0465329e905D5DbA970] = true;
_address_map[0x6863c3d0A5BcFe00077B0f043B25f18C9B0b2541] = true;
_address_map[0x68682BeBbf2AbB94A441b9b58FDaC8E10f1aBF56] = true;
_address_map[0x689bcC934A192Db46383F02CBf098b7EAC9dc67D] = true;
_address_map[0x68C22636C8199a28f5c4425C315850aFA9D9C836] = true;
_address_map[0x68C8C058cbB36b70C43923B77cD6fB6429110f75] = true;
_address_map[0x6913c8E131061c51d182E0cAe31CFf4291FFF7e8] = true;
_address_map[0x6922a8AC144Bf24e566A2FE74562A6e34280973c] = true;
_address_map[0x692ea3DD7Bdc552642CC7c4BD9A62Bf8e8F78fB7] = true;
_address_map[0x694f80212d0E36938A93637bE23257d0B7d413B7] = true;
_address_map[0x6956A9666D7d6035912E138f1c795161C86A78ef] = true;
_address_map[0x696A3b952B5eF6f7d4bCEBDda00d40F0e0aad456] = true;
_address_map[0x696F6DF82a5e8e75F0a3Df998e8bAfbf94c3E2b0] = true;
_address_map[0x69795CB9e9Bd4ee392F5ec4e6a9f37bE948A07f6] = true;
_address_map[0x6981ffcf2393A13A8226072d99a37D60F3ecdF1f] = true;
_address_map[0x699B68c80Dc7442d74A829f11002Fe68157425fc] = true;
_address_map[0x69eB91549E154D2e15961AaC9A1cBa59D8AEa07c] = true;
_address_map[0x69ee5F92A21E83fBbB3D00FF424a7C34dBF81acd] = true;
_address_map[0x6a9414367Bc06e4eE70a74510dE15adB72C72EA2] = true;
_address_map[0x6aa118F0f069550B142691c8F17b725363319d50] = true;
_address_map[0x6Aa9D1BCff264e569B43c97e57D41ea252B3B9E6] = true;
_address_map[0x6aAD7892d964b7Bc4DeF14d6c87628a76d3BAac8] = true;
_address_map[0x6AE992a086f30b01b29353185b69dd04dA11491a] = true;
_address_map[0x6B3C18e96367dFCd34CDA57730f0cA44b6481c5b] = true;
_address_map[0x6b5a26Bd68da899FE3Db29f015D12386a3bec2dF] = true;
_address_map[0x6B5B32DE05Dc6171d4B080Bc003AD79399C4A2a5] = true;
_address_map[0x6bdA22Dc9E344FB0AF20eD43D5486c4cD3F99a3f] = true;
_address_map[0x6c104B4dfbC6C7D226E19668e464d7eCEB7F1B0e] = true;
_address_map[0x6c5caf8eAbf481b57e33df132fD7C499D4b6311A] = true;
_address_map[0x6C66EB13c1fd25d018F1dE0Af4a67426fbeD5e2F] = true;
_address_map[0x6C76e8E7D44046EFc5F2BD6C07227b22C40B1d1a] = true;
_address_map[0x6c7bb21c50b4185E85C4Ae5bB84D55078067196c] = true;
_address_map[0x6C7FA74a3bfCf1452634862bAc71bA101bc40760] = true;
_address_map[0x6c96f04729bE8B4E4D010cBFEc5Cb6FC7e53E4dC] = true;
_address_map[0x6c9a5A4945926DE28aA24A1D1E780eb8A15a6f77] = true;
_address_map[0x6c9C4181103e963a8055aA46fCc3E4D7b2bD37Ec] = true;
_address_map[0x6CA0F9eeC69695E3607B8822F52b0a19031a4f90] = true;
_address_map[0x6cA399b7263e01b4Ec6FAaF73b42af9D5B5617bD] = true;
_address_map[0x6CA671eD5474Bf3c25d39aD0d9D40528B3470Ea5] = true;
_address_map[0x6Cc41326168beF2C70Bf378Cf910E4feb68CE18e] = true;
_address_map[0x6cfc4BfF2e14e97B3c959BBBD11163B192dC3089] = true;
_address_map[0x6D06ce70E9F9d3706040319c9d14729A7d66b066] = true;
_address_map[0x6d13095E13891b624B1d42D26f310586a3584611] = true;
_address_map[0x6d713f7E3D3025EC078C6459242B049168b5Aec8] = true;
_address_map[0x6d716f5befD3d37EE464f015a290fA873c3609B0] = true;
_address_map[0x6d93F408EA12d980c32E52249b849f9FF635dAf3] = true;
_address_map[0x6da6c507cC52b6768C7716bb5de0E8D2a5Ca8e36] = true;
_address_map[0x6dbf0ae2e4690d49ff6Eea11088A9b97dF385794] = true;
_address_map[0x6dd01F10eD673e14063f311f01f631d47F213Cfc] = true;
_address_map[0x6e25134Ca53Cd15Face637Bb224E6De702A73060] = true;
_address_map[0x6E77Eb4E19601b1A249965f59ac9e95d8cc51E30] = true;
_address_map[0x6E90d7bb81220759375e26dF520cdEfD4bdc3057] = true;
_address_map[0x6E9b27b7297863B06235204017eecE40721A0a26] = true;
_address_map[0x6E9F5133c03521b817dF9a5DCbA52468a9279947] = true;
_address_map[0x6Ec3062F2De8F10dA36fb1669B4Bd3A5EE9137D0] = true;
_address_map[0x6EE776202E05465111FA650Be173c4B6F7109Ae6] = true;
_address_map[0x6Ef2F8d260ee634E1176782006127230E841eA64] = true;
_address_map[0x6f0fB73D95973D5C34839a0A7cCb08FD66765D74] = true;
_address_map[0x6f4a79aFC7937B317f2eCFc90C289A537456470F] = true;
_address_map[0x6FaBA368DBdD341cAFfad6316860C01ef8D36a5a] = true;
_address_map[0x6fC3b353251E4b36C3e418c0D134014Fe2c4f32B] = true;
_address_map[0x6fE7234a54c7Bb7d98caC77BdcFDddF98709a544] = true;
_address_map[0x701AB292caeF431DE63f54f12A0Bd57b1901a63e] = true;
_address_map[0x701e13222997b35806AEfA1D59bEE4940935cc67] = true;
_address_map[0x703c25e713aEcDaF968261720fA8f8dE1eF672D9] = true;
_address_map[0x7043A0B8fDBDEA1Ad8B772aeC2FC3949926A5932] = true;
_address_map[0x70Aab5dCE88fc7366616340D5fc851a4b46bE442] = true;
_address_map[0x70f819FC7381CEE498e4a6f887C4829B727DFF2e] = true;
_address_map[0x7117386880EAe1E34a4D893248ae8Ca7fd86eEE3] = true;
_address_map[0x711bb36a123fCBB4EDCc478A7dE37fbccAe83502] = true;
_address_map[0x71379FB7DF62704F77a2638bE81eC16aa047fd75] = true;
_address_map[0x71419486B870A360b96dB3F24f9cD044152a3c66] = true;
_address_map[0x716f29e163C24c5e6ec6414F1DF59a94cf49054e] = true;
_address_map[0x71773bC122Fe810B6a83F20327E9AC9377791527] = true;
_address_map[0x71866Ffb7E700E0832aD51f230B75668305493ff] = true;
_address_map[0x71A6EbC077dD13AeafBC6Eeb571a35B0Ea0e0261] = true;
_address_map[0x71C5a6A40D538A0b85CA62F2Db1017475C34B9aa] = true;
_address_map[0x71Dd4836A7a0648EBBfAE357672Cc28ab959a97c] = true;
_address_map[0x71e272AFf65D8B8D978f35857aF191847d940f93] = true;
_address_map[0x71E950feBa55a444BbB9a896c3E2B42e2bEF0272] = true;
_address_map[0x71Fabe589E93307f1B80cAf6C558eb46C82d07Cb] = true;
_address_map[0x72168cdcda9762C48954e61A3Ca9420fC25bd841] = true;
_address_map[0x7268C596d264372ba85b22EEE0AbF2933De40F35] = true;
_address_map[0x726a24eF2DdD80e51Ef73cBeDe3843D5Bd203D83] = true;
_address_map[0x72895eF571D1543dc9CceCaB55411B9CD40A8154] = true;
_address_map[0x7294f2fFEB8a2CDeBF2d69791696DD6fb76D900E] = true;
_address_map[0x72bc0a0caAAcdFC27A610e7B0803dA3860dBe6A6] = true;
_address_map[0x72Bc237Cf598505dC00D4FCC23B1663E206455A9] = true;
_address_map[0x7320A87be017dd1225C02CfF5F4B8F64ae0148DB] = true;
_address_map[0x738AfF9a291ccC8C14DFbc7AFf38da87fFA292C6] = true;
_address_map[0x73a31bc4347265d509A2b7c9466D61a9cF402A14] = true;
_address_map[0x73E6eA392940fFFbcd1Be09546E79bA41Fb907f8] = true;
_address_map[0x740C0BA3BEe0A1A136FdBcCed5a74e1fe89f0041] = true;
_address_map[0x741cdb0FF08751d55039097c6379f136e468E457] = true;
_address_map[0x741E2D5F01c888Aa4EB700B9318DeD801469e583] = true;
_address_map[0x742103a23151f7f4F4EbFD6e2c2B768885D5A4d0] = true;
_address_map[0x744D8C7a27376B32aD167A0D7c6e2479b56D8303] = true;
_address_map[0x74a4e3b8C45Cde63bc265FA96dAA8f092A08aCD9] = true;
_address_map[0x74c28B35813bE55d8e23957C95778C47BD6D143C] = true;
_address_map[0x755BAfa1C72fcbc7Dc0049FdA8624bb3c4C7F25a] = true;
_address_map[0x756B9c2dEA5aAE80c69EF6fDeb0a122af0114296] = true;
_address_map[0x759be65C9527878aaFC2a7972590f0790E8615CD] = true;
_address_map[0x75BD797761801ee681Ceb7cD19A28395d52F4db1] = true;
_address_map[0x75Ee92f7118ffDF6B809Dd6287Da89A85e142829] = true;
_address_map[0x76023B405516641711B179ffeDe2eEA956dC2ec0] = true;
_address_map[0x7608Ee370254ad6C46eD20A32a8bcE5D5Aa3d836] = true;
_address_map[0x761b9557937E2E386ff40a86C8Df02f5bD5af76F] = true;
_address_map[0x7631a6950085C443be8eB24909FF1b4AFd2C88e1] = true;
_address_map[0x763f9A8B688b59AD159863f3bBF306B4288cAF6d] = true;
_address_map[0x765de586FA07D134bBd1e8a06cbb3Ab21e57FBA4] = true;
_address_map[0x76bc6C47271140Cd1dc28Fff6925FE5bF53673Bd] = true;
_address_map[0x76D717AE4Ff67C385196E0D4E7D830d464EcC706] = true;
_address_map[0x76fF4Dff89fb4D642120E53e3369BFDf1c3eEac4] = true;
_address_map[0x770536008eEC48A5c1DcA438d3B54C34765C980F] = true;
_address_map[0x776a5604B5C4aAB1d31ADE91A05f4b24f332f87B] = true;
_address_map[0x7774829760Bb087a5a8D0db9c4B6313561CCe6EB] = true;
_address_map[0x77c8B32EEd1F07240BcB14E9E29Df126250808B3] = true;
_address_map[0x77FC119A4DC2FC6d2Be73a9F2d7030259B05B27E] = true;
_address_map[0x781c76788f1227253327De365DE9a2dCe1C0A662] = true;
_address_map[0x7887f9ad86532c2e8b83240c0Aee1c807fF36DF8] = true;
_address_map[0x78885c27f974637080711c8CdB45079a43941F75] = true;
_address_map[0x788c5967995f7E1eE3d3400C3269cd4AdcbE224d] = true;
_address_map[0x78A1B3694395213edeE90B54cC970C9E45191A41] = true;
_address_map[0x78beE05Eab6f9768071CBA90b46b5D17c9dA5D32] = true;
_address_map[0x78C003144Ebe84F54d43bA58383054a3f6E17047] = true;
_address_map[0x78c4B4A8BB8C7366b80F470D7dBeb3932e5261aF] = true;
_address_map[0x78c7F34a16Ae8724Bbbe2ec0b4207b0F3890eb6A] = true;
_address_map[0x78F3Aab3E918F2Bf8089EBC3698f78D3a273D6B2] = true;
_address_map[0x7936040AeB0152cC6BbF4d16Ae9CE7c5E72313B8] = true;
_address_map[0x795654D6879C4039b7426f026580DE1Ad299C19e] = true;
_address_map[0x79569C476E96a5c03730aBd064CDEB27d644660B] = true;
_address_map[0x795FAD8B222D7F9B4d292fe4996BDe662b8C07Dd] = true;
_address_map[0x7980591c5D739f197D374b046Bb56EE2f2C3D53B] = true;
_address_map[0x799fE7f82E819f9dE651cF95f7BD716225454D65] = true;
_address_map[0x79B4446Ed42027Bf1063DC9903E16293CE27B0af] = true;
_address_map[0x79ea66e4BF569cAe005eA8d5ca29A9795FA0Ab9e] = true;
_address_map[0x79fbC2BE54Ffc434300b493a42d7b17280bd0C81] = true;
_address_map[0x7a0f60678bb4E3AcC18f704CEF58F6650611b30A] = true;
_address_map[0x7A23d19D9947708f67Ec54021D661affD3A4055f] = true;
_address_map[0x7a5Bf23E370a1001E854049a17aa24eE7E17b9cd] = true;
_address_map[0x7a5f13988bFe6df7095d49Cb9A811e67c65909Ef] = true;
_address_map[0x7A80a33a3E3f19F03A88317ce6d880b2542A543f] = true;
_address_map[0x7ad42F9b8F68Ca163ee1c69DF8465D89DDbDA081] = true;
_address_map[0x7AFF760001757BB3E73CaC6C1E83621917Dd63dD] = true;
_address_map[0x7c2CCA7f0D7008D718ABdF0c8051A0a44CaaF54b] = true;
_address_map[0x7C4F47A03CE64Caf9Bfc15129d42d393DB032170] = true;
_address_map[0x7C97d95Ee6248955a3338909Eb9fffa2812798F8] = true;
_address_map[0x7c9883872f54826ef3C5e9aDd6505B929012328F] = true;
_address_map[0x7cCc47Fb90529057FaeCF1389C37962189Ef3649] = true;
_address_map[0x7D14E7946Ce287164aa7eF14A140C49CBDba0d73] = true;
_address_map[0x7d1dc40218B355efFb713cf3A86811d789a4902C] = true;
_address_map[0x7d33a6d067e73e637c9Ae2435AB9dDc933eA4d1c] = true;
_address_map[0x7d40aB4A815714F0A002cC710E1CD9fE2Ab373Cf] = true;
_address_map[0x7d5489954f4984B2d80898Bfd0bd35E5b97CC999] = true;
_address_map[0x7d8CE9DBF233EC9A368cF3357f924B9EbAf7f4fe] = true;
_address_map[0x7D905897539Ba45eE7BCD2f3da3E7670E90866d3] = true;
_address_map[0x7dbbC7E9226Fe57b31293fB1583Bd00E0366d782] = true;
_address_map[0x7dCa82f04863292Fd3009b291500a900a5032645] = true;
_address_map[0x7E0891992ae88Ffd25D2a34bBa76F1c75Ce4ca85] = true;
_address_map[0x7E3Ed68a06845ED4565ae3134671dfDB89083358] = true;
_address_map[0x7E4ec061602FB7C5b6acaF9DBcb65a61396aE7ae] = true;
_address_map[0x7E63df8175b03cDecFabE8E0fa425738180b9Af2] = true;
_address_map[0x7E6B3bd0421E207c0ee479483327F65750C2957C] = true;
_address_map[0x7e80eaC5a7462ca08b954CA5Ae5bba8852756482] = true;
_address_map[0x7eA5f3378defC303cD94C37824d604F347d176E9] = true;
_address_map[0x7ea992Eacb226322f24F75F69ebC4934ddA319cb] = true;
_address_map[0x7eAEB8395937887D6E5FF3Bb6df793F4FD993C78] = true;
_address_map[0x7ef1eD1a5B31d488f369F783697f6A71f4Ee215f] = true;
_address_map[0x7F2e54d53258Dc45b8581f11F924075146608D19] = true;
_address_map[0x7f32079d87C849AD9fb566762D49B754A9855BB5] = true;
_address_map[0x7F42d15445807B5256A3D6d56A828aF70BCF169c] = true;
_address_map[0x7f54d35936af5D484Dd4d9F35EB2d7C872852657] = true;
_address_map[0x7F7955c49BBc34c7a3d78f0E34B54A1cB5552D15] = true;
_address_map[0x7f8171730ba67eAea6B83Bc6eb188bF0CAFd5851] = true;
_address_map[0x7F86E8b5c6FfF10256D1c1171F14B9E6E15BeAc4] = true;
_address_map[0x7fA5B4277bEeb25276b76D171174280A8da9C9f9] = true;
_address_map[0x7fBec6E6C3B42D83FbdCEA141b8533E09eb75Cc5] = true;
_address_map[0x8005CF1dA47ee8F9c4717D65F7159839f443A4D0] = true;
_address_map[0x803E348614ed68Bd9238e573378371023260C7C2] = true;
_address_map[0x8040b6001CB52d5125E7f60278676034F038606d] = true;
_address_map[0x807e0733878AdeB94e161F714e8e84A9E92D1223] = true;
_address_map[0x8086F0ea451FC9ac0D73aBCe54AFdd397a8ecB9A] = true;
_address_map[0x80b54c451B9f22d5dd03FC00fA7FC7437C3916dA] = true;
_address_map[0x80b9F5E1bC18CB1336bCcCe034e7477312192F91] = true;
_address_map[0x80e66Be5DF1B6d2BEE6a3652E1854c68850ed9FF] = true;
_address_map[0x80e9E1E885F838655D9c79051d380E9Fdabaf9C4] = true;
_address_map[0x80fB08af3129f1DceF47CDeD9968d22962194D4f] = true;
_address_map[0x816bb8e17b1544Dc6f80c673c3759daAB26e7FA7] = true;
_address_map[0x81c51Eec81A573421BEb122Bbb235119Fb6C88BB] = true;
_address_map[0x81Dfb05df1E649004BF8AC3b1F2721622b6CAd57] = true;
_address_map[0x81e1b2A99906234D4A0508ecb6230a49eCb83d7c] = true;
_address_map[0x82023a7bf582E1C772a1BcD749e10C0AFD7aB04E] = true;
_address_map[0x8204175DEf438eCb8Bf1842456d2f34c57E6F4d1] = true;
_address_map[0x823F4D3c872b2077fD3efbaC38a31121e460a562] = true;
_address_map[0x8252737Ae10318D6FF41beb4E4d3aE6B7D08aDa7] = true;
_address_map[0x829C23A03195a647a6E685065dB8111711A0159B] = true;
_address_map[0x82a4C9E2ae0213a417Bc02CfA5be092E26456d8a] = true;
_address_map[0x82b936fBa1000cD83e110A04D5BA70208F59a0e2] = true;
_address_map[0x82c854504F266dAd4a7eA9E448Ca7B1572AebF1C] = true;
_address_map[0x82dABFA46cdb406F2483aF233b97E7B8f33bD46d] = true;
_address_map[0x830E79EeECe71a433f212775C9db7404FD10fd93] = true;
_address_map[0x834ab2d1c13Dc72572D0c0F16dBFa74e2C1DF0Ad] = true;
_address_map[0x8350589B8949041FfC6166E5b55Fc1948707A6f2] = true;
_address_map[0x83515f05d4F4E6C21637936bB4Ff1D1ED8e0acB5] = true;
_address_map[0x8352c6b72B80c032dC83eEeBdD545f39319b2410] = true;
_address_map[0x83622d978eC7f14A765F90c844e409b99B3E9165] = true;
_address_map[0x839230191D1a25aa75e4d42580F14c98087a27A2] = true;
_address_map[0x83b89A5d683E0ee4dee52D24eC60e4a8e7d76022] = true;
_address_map[0x83B96AE86F3c3ee8767a6C417b79B387e9e21dEF] = true;
_address_map[0x83Da64098882C2545F563C01BE763446f9B95c40] = true;
_address_map[0x83E336aF37EDf60e31E872Eb8daBf7EAC04175b3] = true;
_address_map[0x83FaE5bB37c6Df085289c92D15f51D6f70C412EA] = true;
_address_map[0x841c92Db5C4755186567FE1E76317AB10988f746] = true;
_address_map[0x848270522A028C3e7Bc9766377806e1234642c0a] = true;
_address_map[0x84c7B7C382D724DCfB989F03e5270a9842ec995c] = true;
_address_map[0x84c9E0dEF03bb2439A2Cc43873F1E93c39DB688D] = true;
_address_map[0x84eB10CC85c9391f4B4928c0be3A3bf356C49541] = true;
_address_map[0x84f6a709C1986f60B4F988BeddDBB456Cb6028a8] = true;
_address_map[0x84F9d5223E75b4F493Ce1F791b568dF0DC56193c] = true;
_address_map[0x85040EA783AC2AFC4A0Bb19a2d65766c55E972fe] = true;
_address_map[0x850c2228A32e0F491db4a82408ee3349Ad315eA5] = true;
_address_map[0x852d3ff2DD482901978427D371AfB7E2c0274649] = true;
_address_map[0x854283824B35B0E572cB684d2efAC0CfD8FcE255] = true;
_address_map[0x855f7660D8a5DCAa3C87Da75F2e15FA19cC34224] = true;
_address_map[0x8575caE04AabA24d4125334fBCe77452730f0670] = true;
_address_map[0x857Bcd56B8Dd57a0f3E08ccFB315Ff54db2c6344] = true;
_address_map[0x858B906E8aCcef2A9b027abdd642dCF689A192ab] = true;
_address_map[0x858f71b706CA720Fb03455A56fC875e1D21665ae] = true;
_address_map[0x85b157815Cce5E7121F69a7Caa7AB6c56Ac9ad7b] = true;
_address_map[0x85C9a2aaF8fA6ac97D4414625Fc4583c98a88e2d] = true;
_address_map[0x85FE64C0BF8623b9C1c21010bdF642eD714bE00b] = true;
_address_map[0x861F73c955AB05cD6F6326Fa75BEF3Fa8D2a1ccd] = true;
_address_map[0x86943D27E920d86DCA508081c619Fec5f1C16bcc] = true;
_address_map[0x869A15b57cb37fF5A16BC8cCD1E10dFB66709382] = true;
_address_map[0x86A4673c3fD62EcBf514B63F51081ce6A18ecDa1] = true;
_address_map[0x86BbC7E23a96beD8A53DF617e3B562352119E308] = true;
_address_map[0x86E1265Ef4cBf08f22565Eb5A3183aDE12207165] = true;
_address_map[0x871E0C3d654E56cdF71fA075f501D12978C0EFb8] = true;
_address_map[0x87250C1960d4b677451770f28078aD5aDd2878E5] = true;
_address_map[0x873447830446CC46cdBd073ad50e936fc645fB1c] = true;
_address_map[0x875bA4323710D92c4E37B23421db462B00b65F09] = true;
_address_map[0x87702B5f714b9303ef725E522CBf7f67cc55a147] = true;
_address_map[0x878065AA5068FB853a6b326Faf3E1C3493DBCC9e] = true;
_address_map[0x878A40EAb79d4A0f235c9E3589137D832740C658] = true;
_address_map[0x87BE53C6B3a53191bBc3f0f61a14b52ae247a96f] = true;
_address_map[0x87D0608903A7eFb4320D1DDa92F1A37194b0c37A] = true;
_address_map[0x87E7D061e22c95cD6AE3bb8905cdE548D0D46457] = true;
_address_map[0x87eb811d205921343aEEd69938A6ffDE61f7c717] = true;
_address_map[0x88126dc4224e8655ddA7d8a5266daf4b0F0e277F] = true;
_address_map[0x8844d2f582380996D4b7E0a87FE482eB70e72750] = true;
_address_map[0x884f0F3CA066C6a4b04c0c4139097EF113af2E84] = true;
_address_map[0x885b73C3586576541E18A8B84f6F0B641a6c1eba] = true;
_address_map[0x8861512Cd7eb95E5bE424a60E63aF002a2bB1b9D] = true;
_address_map[0x88619a685010de8C63af6d1FA2F4F327E9cA5dad] = true;
_address_map[0x888632b43d35b476783B8d9C767c0b9e27B68888] = true;
_address_map[0x8904952C3a3AA9040EB7C3d3a1A3315b26A840ef] = true;
_address_map[0x891Bc283d645076Fb6F841B7Cfa8174b0891A5a9] = true;
_address_map[0x897e7E816aed1C03fc401357a4a7c0a55b5718d6] = true;
_address_map[0x89989F83b49AFcDdffD0b381C7376cD8769bAFa5] = true;
_address_map[0x899E2857b784fa1e1f3dFF254E6dE84F83a5926f] = true;
_address_map[0x89a6e13B5d5bC1ca3F58256E96d4108f830a3D05] = true;
_address_map[0x89dE0739Ba6bE21980437504e89b4c38bDf70036] = true;
_address_map[0x89e52c6b7Ea456A1f8fd5E0cB765C99C8f44826B] = true;
_address_map[0x89f2CEF6B3da0Cddc6F1d87Bf2aBd7d913A007EA] = true;
_address_map[0x89f60584895FfbD5D2d40Fe0C1187d7dCA078d39] = true;
_address_map[0x8A05Aa3fc3c4B84DfF7DEA79A33313B48823D2ed] = true;
_address_map[0x8a0a677d64E5A428BDD04C2A96610010835396F6] = true;
_address_map[0x8a24126235B800870EbC393B10c655dd83A5fd1C] = true;
_address_map[0x8A2755E6Bf19f22460D5F2C11452C21e600dE5dA] = true;
_address_map[0x8a2Da7b829C3776179344280Ac96B4A3a57787b2] = true;
_address_map[0x8A2F877d4F530293ED67Cdc6D57b2145623770aD] = true;
_address_map[0x8a6e1860a3f7BFCC688ccA694Ec5882BB2176062] = true;
_address_map[0x8A7C1422FE789c276E21D1792AfDA90f638Ac5cC] = true;
_address_map[0x8A84bBe1474EEA9EdA0e392974D0C4FEA2f1a055] = true;
_address_map[0x8aA2EECA4983bCD3d60e371F9300fF2d282687ed] = true;
_address_map[0x8AE3075D1c6492968b8A92153594748cF247fd0e] = true;
_address_map[0x8b01882CDD0d79fD08D1e7a5d0a581b1D55017a1] = true;
_address_map[0x8B095365E9831412147b5dC07e644dcF87325106] = true;
_address_map[0x8b0A2896aa96B5D8f0b9a288F3f22828bCdbf8Db] = true;
_address_map[0x8b1723a028fabd8edae8C52D6b731468471432Fa] = true;
_address_map[0x8b34b80D1d89eDFEf403BBFe0caC60280387CBdD] = true;
_address_map[0x8B47AA7357c71A31dA37f68f70d0452626AfDC07] = true;
_address_map[0x8bbE549a1c417fb305F8D5f3243ec6Ba112F8bE1] = true;
_address_map[0x8bC5Db6Fac4DBD41E42353CE1F202AA1c06B78E5] = true;
_address_map[0x8Bf5604D338Aa4DAd105D88781411D441FB67090] = true;
_address_map[0x8bf91C998721203Fc84Ec010C8EDEe5Bed159e25] = true;
_address_map[0x8c8cD465bB7831Be5c27985e30C249D6f3ff5c66] = true;
_address_map[0x8c95c6d105F356d34C493c88A887A781F7061716] = true;
_address_map[0x8CA65A3Ce90d31a88FAa747c695183C2aefe537f] = true;
_address_map[0x8CE2408C7f94526938b1c252fC1d5fB9458526BB] = true;
_address_map[0x8d092a6889Dd2FBcd564d1d9B94bE384C3BEA02c] = true;
_address_map[0x8D95e90391960f9205A3f440AcD28818040b9Ef5] = true;
_address_map[0x8D9f95B34Ee97A1cA63b0AD8c559DDC55ae76957] = true;
_address_map[0x8DAD7F0F1401633661eaB2f8ee17D7f781F3F705] = true;
_address_map[0x8dBaDD6a1Fa8101d347F30b798E437e2D68De324] = true;
_address_map[0x8dE01c84FD1FD9056a70Ee94f218d08228FDdf2d] = true;
_address_map[0x8e018A444B58f01d7b67628690843b5178192d38] = true;
_address_map[0x8E34978fB118160E1a493374EafE689dd6767599] = true;
_address_map[0x8E4bd706C98A680CbF10075eED5B1DBA616287c5] = true;
_address_map[0x8Ed8469d40CD2B1beB260Ff3Ae8871B3EeEEa4EC] = true;
_address_map[0x8Ef6264332cf707d8f8f47661E2faB223001D6AB] = true;
_address_map[0x8f2aC40e635E6194500CAaB19a69E84aEcAdE79A] = true;
_address_map[0x8F75a38fB833Cf885bF73d0D742d7655efc6E3eF] = true;
_address_map[0x8Fd2e55836878D2625dB43C6d020dcDFc0d12605] = true;
_address_map[0x8FfA8d00DB5df56a20C30B737c5EFdAaBE140Df4] = true;
_address_map[0x900dEB40260B3400dF7dA62BDB99386c0f717a03] = true;
_address_map[0x9037CbF38ce8B103E2c9D5413442D1BB75d27c14] = true;
_address_map[0x905e82f9705e2962E340573BCe14Bb2f2a4E4858] = true;
_address_map[0x906D3c28dC17e47C71cC7cA712c8Df068dF396fd] = true;
_address_map[0x90713032554b18Cc4801d6A703beC02796CB883b] = true;
_address_map[0x909FCBE08cf48C15807c626996dCB0aAcde73548] = true;
_address_map[0x90B30EA69262d9D1cEa0cdA3fAF1E84343D2D2e3] = true;
_address_map[0x90F247961EBA80d66970d60FBC88c437f7810E57] = true;
_address_map[0x9143F58DD9866235Bf6DF0d4d10F087f9D3518E7] = true;
_address_map[0x916dE80B38A0A92A58d78be4b357669Fb5E8CC5e] = true;
_address_map[0x917C24aefe25d6e8d03C1F1e48ee60664416850F] = true;
_address_map[0x918a50B7F7B72ad51B876B8B520C06592C212411] = true;
_address_map[0x919Dd27C4CE3d9F1ccd17D2B46A9B9960F0e0932] = true;
_address_map[0x91B44B61d7fb516Af875F29E19fEAFFfCC4b9AF3] = true;
_address_map[0x91Df79D20EEb42Fa55F7a8D00B093AF3D1f46b34] = true;
_address_map[0x922A520549a285c4eaB1f3311F18056F07ec72A7] = true;
_address_map[0x923EdEd7c4c65b0250ADbCC63b62372e1fDF140E] = true;
_address_map[0x928135C630cab1C5bD61BFF592C2be977A0AaC1a] = true;
_address_map[0x92B0Cdab14a590CAa875b90ecF04D94B70f10221] = true;
_address_map[0x92cf222D240682926c191f7683a379eB67820A08] = true;
_address_map[0x92DDdff0C7dCC5FDC86084208B9aE24BD0d6C4BD] = true;
_address_map[0x92fa9Fc0F1917C01bd9D87402E011e2f83bd537D] = true;
_address_map[0x931bFf6f70404930a802c3dc073eDb406C76Ee28] = true;
_address_map[0x9339002D6bb08BdA328BC60A6dB524f3a945E5bD] = true;
_address_map[0x935843374219e7F164bB7EE4Cbf356A45dDaEBcd] = true;
_address_map[0x935Bc915004736fB226381f5FC803d8196bF8cC6] = true;
_address_map[0x935D95aFDC21ED5f516622e8432B11cd41aD17b8] = true;
_address_map[0x9370E76998689E65Be5Ec05e41B64f6dD531F809] = true;
_address_map[0x93782c2a7A700896De0505Cf8D2aEc10cac5657d] = true;
_address_map[0x93902eaEA97260fa76c5b296772ffcFe5152CfE7] = true;
_address_map[0x93a51A8280Cc349ac6254AfDfd6EC77145244803] = true;
_address_map[0x9411b05DC10808223dAfbA58e3F5b8aC4E0e5536] = true;
_address_map[0x9412BA404C46Cb7B4Cbeaa2b883B84C45d31D2cD] = true;
_address_map[0x942c842b7a5DDf8586e09cfFa79dec191c26C538] = true;
_address_map[0x94395935b293aeB795C00eD77ca9904c52C44Bf3] = true;
_address_map[0x94529CE25682E3340B2d1E788Aa9aCa02011c040] = true;
_address_map[0x94564Bc541f637E35655F44bD365E864930Dcdf7] = true;
_address_map[0x9495449441C8D9bE8747961cbE3b5AED530989fF] = true;
_address_map[0x94Bff8f8F370CD2F5Fb0c6F16DD4457a30F2d4e1] = true;
_address_map[0x94C7A89344CAF9c967855e98070f3A9e9DC60a81] = true;
_address_map[0x953321C0bf7Bf48d1c4a2E9FC94d3389405692dD] = true;
_address_map[0x953DEEa7b91Bb80C32BF501490C9DF02cd8Ce9Fa] = true;
_address_map[0x9571a1053203144eD163e4Da34a71C984c6606d6] = true;
_address_map[0x9583d8a433f004Be19B18316c9089829F4438566] = true;
_address_map[0x958d018C5081D8F2290FBd05B41182E0109eEc7f] = true;
_address_map[0x95B7a7dB2357F3c9E2D5E2F85057CD04B105F29B] = true;
_address_map[0x95Ca2998B1f5769dD16FFa42ca58ab023A4987ef] = true;
_address_map[0x95cb6eF10022A1B307EDb93183Ad7d5D38Dd4EfD] = true;
_address_map[0x9609b0ED2094e2D69099b508AFBa334FF5898C05] = true;
_address_map[0x96682dDbFA62BCe8BAf0aF305eE35eB4a431015f] = true;
_address_map[0x96783DC2eB0Fb1352f28DB388b7ad9Eb00c1259a] = true;
_address_map[0x969cCCf71357D3895c425dd7e606f0837559a335] = true;
_address_map[0x96aBDb641a4a2deBF707E92293D5160dA352087c] = true;
_address_map[0x96AccC9F06CdF727F50f081ae739F8c903c74A4b] = true;
_address_map[0x96c54d9e35F46Eeb7c1B98e041752Ba27a0dB014] = true;
_address_map[0x96C824eF5B05286496C2F2a304D942bfb7e3226B] = true;
_address_map[0x96DD5548cc8b2887e26A53CB4954117d0Ac6534A] = true;
_address_map[0x97093eF89CC93613937ca6880F4fC5Aef4eD0ba6] = true;
_address_map[0x9713d5d0092FD52Df057ABdf73e675B11Af59760] = true;
_address_map[0x97210095b7e1dd21F5E725A92D126c816Acc455f] = true;
_address_map[0x976E424b9f438f01ADA3de1485Ea4300dA71ef59] = true;
_address_map[0x981117e47Af32001DF4e8BAfd62Ef8a1f96361B9] = true;
_address_map[0x98153d92584cdF293FA552B9174302E8Bf1E1324] = true;
_address_map[0x9854Bceaf0720f9198cd98E2Ce570f6B3b4bCD1d] = true;
_address_map[0x9864249ba57309859ff024F88264FACD19895F93] = true;
_address_map[0x98a58d5fe3ECe9809Ac480Fbf170390F60db5c2C] = true;
_address_map[0x98A6E1811D90383516B07ABa94C59830009E6E71] = true;
_address_map[0x98B1F0E43589eEaB2B47eE8380eFb471BCFa7d21] = true;
_address_map[0x98E65A6756b521190741Dd4232Ed6b36C80F15f6] = true;
_address_map[0x98f31187e9a3EF67bFdB3e262f42C18DDc20D813] = true;
_address_map[0x98F7cfDd0BE4C2326C92acA623d69310fa3847d9] = true;
_address_map[0x995781BD78AdE4a430EB575F1Dc3709B8Fe405B6] = true;
_address_map[0x9974F2704310ca47f27C215B1B95B4597CCAdE25] = true;
_address_map[0x99cC24969b9e93dB52f3E8aA9644B27c23198DD3] = true;
_address_map[0x99d04Fa211b73E7dD6376876B67678c032659C2A] = true;
_address_map[0x99f88161CAf548CBA5831b6d787fAa79158a77C0] = true;
_address_map[0x9a0e27c335448Dd5A92c5eca315258d608DDde5B] = true;
_address_map[0x9a357D11114E4e3CFE7057fAde6864b8AC5FE4ad] = true;
_address_map[0x9A3e0237919065AFAB5363180037917A8A9807B9] = true;
_address_map[0x9a5012cf8E9a8Ad14513A99f5c53215445479771] = true;
_address_map[0x9A74796Cea29b9661D4D0DD07c217F2ac4D2b0eD] = true;
_address_map[0x9ae72C2AF70B18DA6088f8d95aaf35Ae43534a8D] = true;
_address_map[0x9AFbBF3df089A0C572D8F7B8683248395592C156] = true;
_address_map[0x9b0eE3395F4834Ae11b021147a8c2413434a3116] = true;
    }

    //--------------------------------------
    // [external] 確認
    //--------------------------------------
    function check( address target ) external view override returns (bool) {
        return( _address_map[target] );
    }

}