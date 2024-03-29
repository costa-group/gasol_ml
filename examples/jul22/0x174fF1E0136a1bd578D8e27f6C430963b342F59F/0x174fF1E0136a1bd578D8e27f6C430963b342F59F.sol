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
// wl_WONDERKIDS_07
//------------------------------------------
contract wl_WONDERKIDS_07 is IWhiteList {
    //---------------------------
    // storage
    //---------------------------
    mapping( address => bool) private _address_map;

    //-----------------------------------------
    // コンストラクタ
    //-----------------------------------------
    constructor(){
_address_map[0xb23392BC43718Ca181747dE26792f54C97E0530a] = true;
_address_map[0xb23Ce42dbb4b5Fd56330d180A667cf273C19323C] = true;
_address_map[0xb25b7a78e894d58b7DAEEE0a1f1d8D1B4a10Df61] = true;
_address_map[0xB25dD4413282F3df1e4b233edd9a0E726d98a686] = true;
_address_map[0xb28b0e59EC8a4055495C6b9317a68cC61831dC66] = true;
_address_map[0xB28Be8dDB3a41db3B493304A3D2A2f6FBF399c89] = true;
_address_map[0xb290417D7c7aAdB5bEd5A310130a32eF4F14AFb6] = true;
_address_map[0xB29479Ef88dFFf8daC466cF6C716e7985c4241c5] = true;
_address_map[0xB296b45361e2a4BEe6800f9615780d6BFd07C629] = true;
_address_map[0xb29842f3a17EAD2D389b884F32aC6965A2b60c97] = true;
_address_map[0xB298dDf9da891D6d1De16301f09DE8945f223484] = true;
_address_map[0xb2b5DFc505C617b6ECd0f7F4516F5E91AD869345] = true;
_address_map[0xB2C1821ffB59cF4B54687548a961174Bc12f37f6] = true;
_address_map[0xB2C5FA82E91A6Be5F316aDCEd8daE363d27e09DE] = true;
_address_map[0xB2d6c5CB175d281eD30363C3E17982BE74eB492F] = true;
_address_map[0xb2E0bAd98d6e66a4838101af1E5a895E5FbB2aC3] = true;
_address_map[0xb2ef6d479c54fC50DEDf884B2Af59087D5a5f10f] = true;
_address_map[0xB30A335117F452B606f35F71dfdf6129E3aA7Fa5] = true;
_address_map[0xb30E9dbf185c439E1bBA2452C80fEa68407C8AA6] = true;
_address_map[0xB31f41CCEE92ac853a6Ffd33ec44D240BCdD0D73] = true;
_address_map[0xb32bA420924DA6694C5476F06673e8f7b6CaE0d1] = true;
_address_map[0xb32C26709a67898Ad3D5557b6052bFc1BFB4E0B4] = true;
_address_map[0xB32Ec9935f9131D7F3D0B3AD1C28cA60f828a395] = true;
_address_map[0xB3479AC22aB13a9d359c1AA0fdf6F7e3D39A207C] = true;
_address_map[0xb34a7CB842b5864daD3589D70Ee291927E58F970] = true;
_address_map[0xb35120bF9b7398610BB372f538aE139601261C45] = true;
_address_map[0xB3557ba0d49bb21b43b2a5AC1dB4b5258b8E6640] = true;
_address_map[0xB35c61dc983C0e49C8D3ee80FBAe6d5B3b79495e] = true;
_address_map[0xB361b55b2bC39099853595bfaB7a87c5c3e350Be] = true;
_address_map[0xb38040D3979386919D5C1edE8A7D4da5750fFFba] = true;
_address_map[0xB38960d106759f1C26dcb7d61F4f9a5dE3664Eb5] = true;
_address_map[0xB38BafC369A66C1a6CAe4839fc277b4e3c6F7b83] = true;
_address_map[0xB3ADd07a3d040Fb47936fe0Ecc05D77324A166C0] = true;
_address_map[0xB3dbc6E7FcAc8606ABC16c74ab972d14E443650E] = true;
_address_map[0xB3E808E9f8bef812b2cB302d080d620EE1Deb872] = true;
_address_map[0xb3E86A37cc734B1cd463568D1F9E3219D52D8d18] = true;
_address_map[0xB3F6e34D2A9Cd604aEA436796D1D99DbfC9E3162] = true;
_address_map[0xb3FcA5Aa7ab35e9785CCaBa46652531E4Ed9Df78] = true;
_address_map[0xB3Fe55D999C86D4Ed45c6f4E382B7523F16199cD] = true;
_address_map[0xB40AF08abFd1F18032262520fD057BF8409E8234] = true;
_address_map[0xb411E7f8182BB0c3516D72d32352c0B8f6ba783c] = true;
_address_map[0xb42618e689328634bE0bB6349f453e95217e4565] = true;
_address_map[0xB43Ca57e0093f1D0298E9eeB472dc9C9E03A92aC] = true;
_address_map[0xb442d26D2b0848E4782cfd7553EE75497f897CCA] = true;
_address_map[0xb4550eda4389B6bECE889A063318dD724b370bc7] = true;
_address_map[0xB4575b33c42Ce8489C44A4Cb5c1BE795fc361a2e] = true;
_address_map[0xb492c35F454B83B2c19eCa5CBEC8e1792C71dfaC] = true;
_address_map[0xb4aE1763353d950f7D1EC626654337AeF7230Dc1] = true;
_address_map[0xB4b5297611B97602E5D8d9D02101710D134394DE] = true;
_address_map[0xb4b977f93B260BA5Aa46f5bB054ACf31Eea241b8] = true;
_address_map[0xb4ba88887EAe71433a5e265aA5d5Db04D90D7b2f] = true;
_address_map[0xb4EDd0c29032DCA454ABD96B1d3eA71B08B4c0c4] = true;
_address_map[0xb50DD27c860ac4BadB7eD5A551B3f0b3f9dc2Af5] = true;
_address_map[0xb513De60ef2eE634AeE75C09e1868DC944C50040] = true;
_address_map[0xB51A30CE640733630C8499e7A785EF06dD8B137c] = true;
_address_map[0xB5339157be76de7c5a796Eb7eae58239bf7501b5] = true;
_address_map[0xb549cF0D11ba35c32c52fc15f090B56fFe9f214A] = true;
_address_map[0xB54b3084A0D32D816A170A2E0d77AFFe43Fb3b18] = true;
_address_map[0xB54E38668e4A4fAf2F20DFF4770FE447Eb508bc1] = true;
_address_map[0xb56c8cfc8235DF176A6594F125AF12D41F39aF29] = true;
_address_map[0xb582BD6748ea758A9b8487C33D37ba424808085f] = true;
_address_map[0xb594a0864Cb9E6ED98f7Fc4350af74468551a523] = true;
_address_map[0xb59532055A20e2e8C635f20554872029aCc50f00] = true;
_address_map[0xB5A2370E6e741c6A12c40E6FF8FC6852D38e88cE] = true;
_address_map[0xB5fdFbbdDC872D08D0203Cd6D69d5cE67Eb4c761] = true;
_address_map[0xb60475771B107Dcb754Ab3859014eBb1C26cCbc7] = true;
_address_map[0xb604ADF39e054243aa08840f66226a78fEeDd4B0] = true;
_address_map[0xb61ea4051D15a465aB096b05E433f7F6c40003cc] = true;
_address_map[0xB66C9De8339EC8fF4949389B8878CDE9cFcBF488] = true;
_address_map[0xB6825fe2feE68e8C0d2781d0D963fbFCf6da0487] = true;
_address_map[0xB6A4b8E0F7820D8767208d097Dd76F42Fb2aa27b] = true;
_address_map[0xB6aA19FD6602C72E3b0E269D74522f6E97693319] = true;
_address_map[0xB6c02537cAa12FfA28Ce7c9Cba68A761DCeF2bFA] = true;
_address_map[0xB6D19aFe6de6C1Ab49B964E202ebBf6b8E590a33] = true;
_address_map[0xb6Db74bC61539f2a68BFaDEC6339736f4746Ff26] = true;
_address_map[0xB709F8f8b0B9c4260d2435c8325Bc67C0881d7ED] = true;
_address_map[0xb7399B1c53e051EFf873FE343b5DAdFb617056dc] = true;
_address_map[0xb742EeF6c499EDFf8AEBC4B67C4F1011F79C0454] = true;
_address_map[0xB753E80Eb2f18723C69a8692c40Ee9deA1df6B47] = true;
_address_map[0xB7715ecB32420cbc2FB9100C3F11C270e358365f] = true;
_address_map[0xB77B93b3fb4902D48313414013b9f3C60Ab7De32] = true;
_address_map[0xB7961d7Fe684fA62eEba6af556C7471dd70B66C2] = true;
_address_map[0xb7A46d35e66cb96678Ba8BE69300ADfd5A50F04D] = true;
_address_map[0xb7A5013F8aBfBeedDEC99027AB2bE4f1D04b61f5] = true;
_address_map[0xb7AFD63bb2D0BeC53adbC4F7DB37c63d0bD1272c] = true;
_address_map[0xB7b4e462b21301465A47cAc3118877776b3F067d] = true;
_address_map[0xb7DC73af4f601BC853C91b9Ae0563342E22e7CBf] = true;
_address_map[0xb7Df7d1F7838885Ed712A967c77bCFec93F6647d] = true;
_address_map[0xb8044715303763008f7405F741Ab47eBe8C711f4] = true;
_address_map[0xB83D79845Ae31E0061d1361Ab203237AD076c26e] = true;
_address_map[0xb886911bC657344eADC585A2C15dB000B42d1f81] = true;
_address_map[0xB893AE8A1824604F6df4Dfde52E2754921ba1A73] = true;
_address_map[0xB8bcebd1F29a9001E4DB7215FFe73FE03e35f6e0] = true;
_address_map[0xB8bD36678373d6479163b1449BB92640A22b6b9c] = true;
_address_map[0xb8bdeD52d0E4F501DfA680D3D5FC0172327234Ee] = true;
_address_map[0xB8c16EB4035e152B31429EC6f41431DF9b1f7C4C] = true;
_address_map[0xB8D577eACAD5c7434b54a40FB3CbeAA363783ece] = true;
_address_map[0xB8d859418Eaf164f0b581E20a10B6E628FaA5E8F] = true;
_address_map[0xb8e0904e63B80cf30cf6d4bAF640deadA03B1C8F] = true;
_address_map[0xB8f6aB7B30CFf81d3B285a792b2917b35C885675] = true;
_address_map[0xb8F73137e2aD74B9f89f7C64f9170A0384f822BC] = true;
_address_map[0xB8f9251192F6caaB0784a869b8E957cD171a09cf] = true;
_address_map[0xB902DFE6bd8aEe747f0A2218Aca57C274a651B87] = true;
_address_map[0xB90778D56Ad6A6912CbECf95cA4C88917B8C01A8] = true;
_address_map[0xb90A6Fd0d17C2EC96c5Bdc98039A64dc8866b1eC] = true;
_address_map[0xb9178D2Bc263c42c62B7CE1941cC2AdB4e623A05] = true;
_address_map[0xB92DED28F8cb6E9cc611664F834A1CbaBc22Fa40] = true;
_address_map[0xB92F57587E1841df7Fefb595310af554721332a7] = true;
_address_map[0xb958ba4C411cbC7a421e0B404267a82479b0FADc] = true;
_address_map[0xB9598a5E09aF629Ad8D85187266C2084d64953EC] = true;
_address_map[0xb975e398A2EaB4Fb8BfEEcfAC5f74101250A0EA0] = true;
_address_map[0xB9B062Efd399f90D1673e74Ebf7C96D5B32E8f52] = true;
_address_map[0xb9b09311Ea697C9bD16B9c41f759B852cC14b169] = true;
_address_map[0xB9c2cB57Dfe51F8A2Fb588f333bDC89D8d90ca9B] = true;
_address_map[0xB9C4a03D3eEE5AeA77662B19570d73C080794d3B] = true;
_address_map[0xb9d77C00d6685D582171b54C068c078f71Ed63Cc] = true;
_address_map[0xb9eB043A7Fa048Bca7c32f4cE3971f7cBEcE9F84] = true;
_address_map[0xB9Fb398651753E9e8B500a60015A469595B7c02C] = true;
_address_map[0xba184d186678A833040097C8995f758BB46b443F] = true;
_address_map[0xba19c18F9E6d561C14c7c6912F97bfE6Bf55bC0C] = true;
_address_map[0xBA285C02e75755CdC9934DbbC45Ea17C5aD65385] = true;
_address_map[0xba5a6413F98727e2d9FC5632b07E8c0DCeC8cc4E] = true;
_address_map[0xba73bcD00c5F1a8C48B2A415399E7373D191C506] = true;
_address_map[0xBa817c78990Dd5633D1452FD9334276fcbBaEfEF] = true;
_address_map[0xbA838e9129D8704E3Ad4c38F7e913304Ab8aC46c] = true;
_address_map[0xBa9b195267c7cDC9A37B9f313B900Dd442fBaa20] = true;
_address_map[0xbAA671743125E2afa3AC2C1018Cab16BA8DCf071] = true;
_address_map[0xBaB5aFb94af15440a27106a0a616E858c8B28B77] = true;
_address_map[0xbaB7a83C3C3992167E53997ACAA5F771Af3354dB] = true;
_address_map[0xbaC0504C31865Ac5F1C242e29f59a686B32Bd0bF] = true;
_address_map[0xbAc7B1e95935E3354468d7149E98eB1bf33eC010] = true;
_address_map[0xBAD73848c943D908c8ED748c54ab6Cd5C90D4f79] = true;
_address_map[0xBaE039C848CaDd71669eBd32a1673722F014F241] = true;
_address_map[0xbB0eeab18724E25D09e24A293B4C53823ceeAE4f] = true;
_address_map[0xBB1b24c4498B8a0341EA7489c2f8CCf284C59e4C] = true;
_address_map[0xbb2f8C932f2C0560cF65cb88aAcC69C5667bae19] = true;
_address_map[0xBB3a0704450a5980Bc547aE5CD6190Aaf5B12FBc] = true;
_address_map[0xbb4b8BA39A465C8346b131e9e37079100cEa2FBE] = true;
_address_map[0xbB78465e227C4bcDD82D699abEC2C64A23e2b651] = true;
_address_map[0xBB82b4D89961FFaCf36DcB687445C7D25af2ae39] = true;
_address_map[0xbB885c6d5d6C6a07e58321b091229a3F3C45dCd3] = true;
_address_map[0xBb98FFcE50DC665DDA280675A6871cB22fCb9aa6] = true;
_address_map[0xbbafd9D581B70E90cdEBEE87bCa28C891d21BF83] = true;
_address_map[0xbBdbD402e1F504394a70F4E41dE15d854BA57d2B] = true;
_address_map[0xBC0a8358507Fd406Fa97ec82aeB6fA057e9603e9] = true;
_address_map[0xbc167C94dD62D030585c621C86C82Bd00D630323] = true;
_address_map[0xbC1eB4359ab755Af079F6EF77E3FaAc465e53EDA] = true;
_address_map[0xBc2F67aDaaaa13d491BaC80fcc6aa71449D74Dd9] = true;
_address_map[0xBC3E746c622a4B8B3f70fcf43C0ff0d4c66452FE] = true;
_address_map[0xBC3fBA3F13d600353A629Ce8213831f168E307ae] = true;
_address_map[0xbC5126Ea9D3A9b7e8353051DC646bfC4fC65c1F7] = true;
_address_map[0xbC517eb911928eCa393fa8be1703cBEF2Dca6285] = true;
_address_map[0xbC713D6E68c502E87d8976Cc5f9f9Cc658621E92] = true;
_address_map[0xBC77470C85b33D99De1B20a2a155bEC98b85d6a9] = true;
_address_map[0xbC7814E035b862ac4416D8059EBe3b1eCCa2653a] = true;
_address_map[0xbC8744370bCb6D5AbF5dE8B4086ecfBB4C5629C3] = true;
_address_map[0xbc8AB9B87FF4e3c8Cfe02893192cd910E05F5Ca8] = true;
_address_map[0xBc9f273C01e24E9A8D97b1871DB5a8B098c0e29c] = true;
_address_map[0xBCA5A2c56e1140dD618dD53cCdbF84B414A00adA] = true;
_address_map[0xBcaC57990F8Edf1a821E5758a3a6AAA9F81A3e69] = true;
_address_map[0xBcBa66A96B330be24133Fa768d94eb4dEb8cFc3b] = true;
_address_map[0xBcbB4091a7a9C268e299d25783C60aD9eE2F9c79] = true;
_address_map[0xBcF55a29Dc6D05b93b6D9dE7486712feEf068D52] = true;
_address_map[0xbd101FFfAC618cc704F005315143dd63b445C5E7] = true;
_address_map[0xbd2455BcCcaCcb1FFe6015732C18523C447b8a41] = true;
_address_map[0xBd354c706b8c14dEc88ce7Cf4A4eF0Ff46c96e1b] = true;
_address_map[0xbD547F4D3FD65f066c5452Ef6e20fC2533373835] = true;
_address_map[0xBD76bb693fe0848659989705dA511F7F31dC624B] = true;
_address_map[0xbD8Ab847b17C0CB66eD634f478286F1403DA135e] = true;
_address_map[0xbD9Ca486Bd6b22BB6e2E863119aC537C40BC60b0] = true;
_address_map[0xbDAE37E9A73905932efaa195d5c8699F4018F9dE] = true;
_address_map[0xbdca6694B76d1Ed5C2A3bbEEfAf0f2d12b750f8d] = true;
_address_map[0xbDCbbf3B180a98846D02eF632aE6059207e2194a] = true;
_address_map[0xBDCcEE1B83f41CDf5D6F859D90c548b085700aCC] = true;
_address_map[0xbdd73737BF2E77508A1119b8e9fb23cBaAdF4C21] = true;
_address_map[0xbDFd5cF644AB11937f4bf83eb5bc0731Ade24F41] = true;
_address_map[0xBe086Db5bd82Dc03505AbD7600F79C0964fbFb0E] = true;
_address_map[0xbe2A4f15643b27587e76b3B4aF93beac007729C6] = true;
_address_map[0xBE3A1133f528CC5762754099e8D320ae74F52E7f] = true;
_address_map[0xbe42C6b9861C4a18733364492458Fe47bd6C15f2] = true;
_address_map[0xbE48872673BC3225894AF2d6d9D046998287972d] = true;
_address_map[0xbe48E92E0696156A3d20343FbE2F93531848A896] = true;
_address_map[0xbE51C0a50bE87AE158d1dcb8000619f20ccC2803] = true;
_address_map[0xBe609f93a2676033d69fDe83adEccC0d975f4a7f] = true;
_address_map[0xbE6E84B1c09a92e3D2Ad257c84d7783255a030E6] = true;
_address_map[0xbE8a225122409604B36e251514E8ac0a93315871] = true;
_address_map[0xBe8A5823ff4Ed1296942559784394271C8f1a7d4] = true;
_address_map[0xBe8EDBa2Bf6a443c36342980681391E640639B9B] = true;
_address_map[0xBE935831Ac7a3cC1ad059a566CbA486C15410016] = true;
_address_map[0xBE97E0D9b07dbEE81bE21924C547A4B6CD13f0D1] = true;
_address_map[0xbE9EF093c582B7603EC5B090895C7Ae216c67Ff7] = true;
_address_map[0xbea2014BDA7b632c574763720Ee7708c92356407] = true;
_address_map[0xbeb9fba89ce58573cbC01434D6f2d56328BF0089] = true;
_address_map[0xbEbb6D2894C78fB48F3CCF87dB902BDD7579aa01] = true;
_address_map[0xBeCA0DBD83ad67E6610c893D51371546354340a7] = true;
_address_map[0xBeee884C2C7B0337669331bDCA23E41ED2Ca05db] = true;
_address_map[0xBEf521865dD5333BA36EbBB1c81CA3a640bD9e37] = true;
_address_map[0xBEFebF764a9c6e092fc6ef26E5B534dc52E4dC18] = true;
_address_map[0xbEFfddcf2E84106f77c2B60445Dc257D65e19a26] = true;
_address_map[0xBf09b8d58180Be9d27825aA36532B25776D602A9] = true;
_address_map[0xbf171D986Bfd1D68036Bb4d4972d6543b637dC2d] = true;
_address_map[0xBf2d0a8b4c1435A92658d36A41F669a65c0b0698] = true;
_address_map[0xbF59a42E19979b9B6F638bB73805De4759d3eeE6] = true;
_address_map[0xbF5BCdE112d4d726C71Ccef2bfbF49C9bB6fD63b] = true;
_address_map[0xbF6CB050941a12305ccADbc594B5fE46290efaFB] = true;
_address_map[0xBf6d6E8E429322aBb1b46C2Dc63d47Bc3D0B4895] = true;
_address_map[0xbf75aEaC07BE26823e14575FEA9B34031F535411] = true;
_address_map[0xbf888addD55F8Bdea699c5F46180c69DBC127469] = true;
_address_map[0xbF923438A135a99712D4c4b3DB413a0817a90f99] = true;
_address_map[0xBf98386D2f2B2dEc8E0399a164Fe3a6cFF14A2c6] = true;
_address_map[0xBFA9D3d1b68aD07b3b780B39b38F0b0318Cf1Ea7] = true;
_address_map[0xbfC48ae787411d82C2A0a7c1448fb06F2f09BeCb] = true;
_address_map[0xbfc9ca1c434ab19E5F75ACd2d603dc0621ef64E2] = true;
_address_map[0xBFdBA82C2B43abCf65eA320496A5B38357E0a6DF] = true;
_address_map[0xbFE2EE3D73D7b1f5FB71e2113003DBED3775FEC2] = true;
_address_map[0xbFf36a27cECA3cfa4930Da9B446C3f98bF899426] = true;
_address_map[0xBFF427a71C481def4Ef51D06ED9e1EB1D4507FE3] = true;
_address_map[0xC0072c5793771a7563F43698a4710Ba56BD6d9a8] = true;
_address_map[0xc019845298DfC7BBAF7e841DCeA92E36CeD840d3] = true;
_address_map[0xc04Cc9E7A9e36bd9244a4d06AC04C891359d400E] = true;
_address_map[0xC056790e2532a73bDd833f5BEf01015aB3A99f86] = true;
_address_map[0xC0671054bD2e02420f9663CcEc71f063dcf9EDDc] = true;
_address_map[0xC09642548fefdb1c4573ed9813C0D60693c28848] = true;
_address_map[0xC0a5ac708bE23bd3AcE6Cc1e763047e24fC03226] = true;
_address_map[0xc0b627877a87c86A14F3b6371b7756262d68375b] = true;
_address_map[0xc0E680dF15D9b5Eff9d5a426DC139CA4E23196Df] = true;
_address_map[0xc1063671E9C059A2A49b1922a5A4451917F9d31F] = true;
_address_map[0xC15f40A973f265DBa93744b3cefC6d42a308588c] = true;
_address_map[0xc173a93E9f8525a5eD411D49D0C006cF19b6973B] = true;
_address_map[0xC174d55ae464943E439E3B6150030398fF00F234] = true;
_address_map[0xc1781E6948d9CB23e0428A8146088D11BE7AD569] = true;
_address_map[0xC1890E9a0e29A3e9dA466c6d234EDdF04Bb13a7D] = true;
_address_map[0xc18A203776FDF1F4744bE437C0Bec4B84a699Ac3] = true;
_address_map[0xC192233c49a10dA30E33F473b340E94C68E4279a] = true;
_address_map[0xc1A000244f1d28239c01ca8e807d06e6ac71E2Da] = true;
_address_map[0xC1aAb6331F3B36F2880dcB6544328A4838bE6771] = true;
_address_map[0xc1d1E108774eb3BaD8DEbe9B154eb04336569845] = true;
_address_map[0xC1ea72FC1D78F94433E1232ebD8B6F95e8163E5A] = true;
_address_map[0xc1eb671e58249c2c3b2b68B7977Fa7D3a034E566] = true;
_address_map[0xC200023258a45435C413F0660Ae749f1f6762a39] = true;
_address_map[0xc205e3Dd0FEb8D4c77aD47b3D86c563394C16486] = true;
_address_map[0xc2218C1F3AFd8D0a92025a6243993b6024DB46eB] = true;
_address_map[0xC22993fC87F34e53d072155d5431F110Aeb5bA5B] = true;
_address_map[0xC23501c3a3473D0b49e63D75224a2785e855c714] = true;
_address_map[0xC2402ddb90E98A4E2fE8f485EC1E6c5B85AEb41D] = true;
_address_map[0xC2495504F919DE0B59D7d59F681853dF8319b93C] = true;
_address_map[0xc255599e94f60d66b7EC83f20664dcFE22b716EE] = true;
_address_map[0xc25E8323dFdc425aB465f49bD1e398326898B7DD] = true;
_address_map[0xc261175ba0619f951b83F1AE497FBE41898a39E8] = true;
_address_map[0xc27ECE6FB06A394e33B87d08a9a1a8dD157f5367] = true;
_address_map[0xC2970E7FAfC1F6828F341E2FEd1EdC2E141Ed88B] = true;
_address_map[0xc2bd6E60929C362ee4917c2055841F9acf3E78B0] = true;
_address_map[0xC2EEB22558207C0Cdb12e5A0db8b9e8164399388] = true;
_address_map[0xc2FA3B09b9b5b7E5510d548bf2c3De2c70f31E21] = true;
_address_map[0xC3220f28940e2a2cc38B6c9De7db8FafECBc920c] = true;
_address_map[0xC333A309549E160EB49F898ac5d64620475a51eE] = true;
_address_map[0xC33b99027b66953Bd4ae8d73D67ecc2E08543a29] = true;
_address_map[0xc36074cC84C5F0BFcf5aDaC560bD50134CA2D389] = true;
_address_map[0xc36CA2F4200bFdC8f2f47f3A582C3f002DCFe2F1] = true;
_address_map[0xc37223575De6591e6Ecbc7887258ECFc6C39748a] = true;
_address_map[0xc377A70fC30c2Cb8EbE5d534B9E30167410Ed0Cb] = true;
_address_map[0xc396e98f5302529B10a23D62C99765945Dcb4619] = true;
_address_map[0xC3a7473633cF8A1598c24c54927B93F6056973b5] = true;
_address_map[0xC3C23C0A18852dcc9aae850B31655491b5E6b0DA] = true;
_address_map[0xc3f71D25b5b15A6BC0d1b233C23e2Ae31334fA6F] = true;
_address_map[0xC42159149B1715435690FB4089633F1377b93eA4] = true;
_address_map[0xc439dD1395a36f5978D9B8Ed7C48045038E31a00] = true;
_address_map[0xC43f35398C1aD990eE761AFdc2aFA36a10D86B79] = true;
_address_map[0xC4497530Ad09e623723DEA6D0a4DaDD9AD279Bb3] = true;
_address_map[0xc44dF8F446f96EE20436F174aeb95D5a5c72B713] = true;
_address_map[0xC458e1a4eC03C5039fBF38221C54Be4e63731E2A] = true;
_address_map[0xC45b80A63360593452a15CfDdE9711726F105E51] = true;
_address_map[0xC47455993D7Cff6248DC594BAA8c3b6FbF9F0f93] = true;
_address_map[0xC474FcF2666d8885BD0D48F942F760448b2F9F34] = true;
_address_map[0xC486f74479a19890A325adaA040E426Fdd0B8725] = true;
_address_map[0xc493A2d5d2287a58050A80ECaD688e06FB7e7b09] = true;
_address_map[0xC4Af2CaC85F4050c139aF2152a4E7EdD1461685a] = true;
_address_map[0xC4Ce4d2B4046F004A874ca049Fbae06cBfad65Ff] = true;
_address_map[0xC4d5b2Aef402311707aAec43a045558f68dcAd41] = true;
_address_map[0xC4fb30F288a8246c77fd18e1E3A06c2Bb80eA43E] = true;
_address_map[0xc510aA879F4538181BA68Ac4f15E0100A876Aa9c] = true;
_address_map[0xC5219714996Df4AD38ebA5c9Ef870e2a9fF06c42] = true;
_address_map[0xc533ddeE84393eA416a2f148Efe3c9e746eF8F0D] = true;
_address_map[0xc53EF2Ea0785822373FEd4a416a75B8961AD7da1] = true;
_address_map[0xC55a76880dF452420f1853A92FE32BC24794FC28] = true;
_address_map[0xC55ECB8B2891aD911d67fc5D1432F1f5fa528444] = true;
_address_map[0xC58e30e014Fe92f05F54364d8EBc01b0c3e26e35] = true;
_address_map[0xc5D7614F1fB80511Dad32094866f7643B782C9db] = true;
_address_map[0xc5E5CF74742119C769121fd81AaaE97B3E4Bb2A5] = true;
_address_map[0xc604E2E850305294286ECec0856c9Dd3e3621023] = true;
_address_map[0xc61F778a4B36D1cd9aee1A3Ca8c22D407cd7AE68] = true;
_address_map[0xC63A5aD9e61b64f18492CB1619c9C1941b4dF3E3] = true;
_address_map[0xc63aFC2e9e23Aea0405991665fA72Eed0e9621ac] = true;
_address_map[0xc64cE6D0Ca8dbB415C81F28Bee1015fa2f9d0318] = true;
_address_map[0xc678577Ac2860EF3bBbF1435e737EC9426664ae2] = true;
_address_map[0xc67B2bb2885Ae63E5B775e51C36E68B52219b724] = true;
_address_map[0xc67CB76849634d8e7C53b27019789fDCF25dA8a6] = true;
_address_map[0xc68d994c192E1FcDcf281f9579C3337d9B618775] = true;
_address_map[0xc690fF44F4874E81b9E0A862b9a2e24945FdaAa2] = true;
_address_map[0xc695D7097A6A4208b33cC7B85f8a6844a90977DD] = true;
_address_map[0xC69751dCdc504fF6447BeF3b76ad2fb79719E216] = true;
_address_map[0xc69C8DDED7CE496e84e6F42a444F125FDBA6FE6C] = true;
_address_map[0xC6b5A168f38EB59F232c28008492AfE969d06e65] = true;
_address_map[0xc6cfeDaAA225Bb433E00d762FE898707a3c077aD] = true;
_address_map[0xc6d27A8273Bd5826DC51A803BFB869d4569Cd07f] = true;
_address_map[0xC6dd5D07eB19520c9BE11c03340C1437df585067] = true;
_address_map[0xc717664FB2a687a030680ff91226a8815975757F] = true;
_address_map[0xC729CC84B66A723A16c2F3cCff21a50D22Cde0f6] = true;
_address_map[0xc72C6a4cA6A2aaEc48E22938a016b2420516d423] = true;
_address_map[0xc758921302a979fd28f6DBA6b95276c93E6aDe07] = true;
_address_map[0xc75F33baC14989FFC269211250f60e497D013A57] = true;
_address_map[0xc77C93Ea76C015Fd84ed037A2e6239b68a5E6D0a] = true;
_address_map[0xc77ec27e6ae82ead54894DFfC7D3F3fE3A09246C] = true;
_address_map[0xc793f9Aaeda85C3C4305e643708070Fb5e7dcbB9] = true;
_address_map[0xC7b80695DB694d731e863E3c3cCFfBD4A30F8FCC] = true;
_address_map[0xC7C6A1F9D57d2Ee64a2c8087b0275241034f3AB7] = true;
_address_map[0xc7Cf568c3c9C6BA46cEd4dd4AeBe96C6a1106842] = true;
_address_map[0xC7D13ce8B2fBb518480636ebBca8476e664063e0] = true;
_address_map[0xc7dC12fe42a3f994AE042057b04029CD4cec2aAc] = true;
_address_map[0xc8056D08A81BdD6702Bc184852CAcACF4dC7EfF0] = true;
_address_map[0xC80D3cDe545B389a32DfbC5df218646965b98675] = true;
_address_map[0xc8144354A4e4BC914Cb30D1B61d1752777BfebB7] = true;
_address_map[0xC827bBe569942eb72158F0e315961146F40D4E3C] = true;
_address_map[0xc84D8113f47f0F3535E22a185EAEDA73216169F3] = true;
_address_map[0xC850A20d1734Cb154f794E4D9660B405E28ed13a] = true;
_address_map[0xc8751a1B9ED6a5562d009E5aD5067B6131fDB346] = true;
_address_map[0xc879F99215d2f842B13bb78c66661fd2739f8505] = true;
_address_map[0xC880089B7ddC6ED7CF4A24e6570b054844A12f1F] = true;
_address_map[0xc886dB8b8CD260f5ee38Ba3d8f8E9324EE27EA33] = true;
_address_map[0xc893416e92d2dD609dbBf3821Cd54Bab1CFCc15A] = true;
_address_map[0xc8A9A8F569C61A6a061181Ef61100E14759c27F1] = true;
_address_map[0xC8aF8Eb1262EeA95673393C567C3AEbF5A8099cF] = true;
_address_map[0xc8b4ee10835C50B816dBd2687F5D725B8B09F2CD] = true;
_address_map[0xC8C23157be4AdF4FFbE91F71D25D624dAEBC72Ac] = true;
_address_map[0xc8c3B97D5F5987701de1809e2A7F100af4d3DE84] = true;
_address_map[0xc8C6cEC663D2Af221bbC1D8684694958e3214835] = true;
_address_map[0xc8d2f3FF5D8fEac92b77b792B47C11Eb27369eDA] = true;
_address_map[0xC8e0e362d3Ed1E453e3c27aA6f8B9dBCEe12C6e6] = true;
_address_map[0xc8f9B217E52e3554F915fbAE45BbF8b73A71e139] = true;
_address_map[0xC8fb7aCa6B31dC905647d31ac0383f5B30d9Be31] = true;
_address_map[0xc90B299bC383351f105905A1186d49E044c9737c] = true;
_address_map[0xC929b6bD739a8564BcB35e978Afe4ffF5b6c3cEF] = true;
_address_map[0xc93913b6aa7896Dc53069dCe401A2e0E38496B3a] = true;
_address_map[0xc93E017d76fF7128c7Fc0F643cd25DCBBdD83D5C] = true;
_address_map[0xC940a81ECD87611cCA1DD53764b50dC2f10225Ca] = true;
_address_map[0xC9483dc485CB9b389137a0f522D7F97D6b38dCD3] = true;
_address_map[0xC95B9A13e364ACE74CC41b88057E67f93d49E871] = true;
_address_map[0xc963d08B09f1E6B7B92694Fd5e7Bb1C452DAA477] = true;
_address_map[0xC975D8CB29e559af29A295FC702C1A0A5a8E0315] = true;
_address_map[0xc97850BEBEa2324931377568f03c6706c3B19bFd] = true;
_address_map[0xC9866D927Ea3E79C3A7A17BB4703c75c3c5D061d] = true;
_address_map[0xC9BC6C926e61c54B775c738C2e41595c665C3B5f] = true;
_address_map[0xc9C282E0cdf22C014e1D3fCe830681FcAcE49a71] = true;
_address_map[0xc9c96Aa20B0AA43cEaE7f7AA5118E6037a9Bd9DE] = true;
_address_map[0xc9E54077c793AEf729D757AA38E27e57dA777395] = true;
_address_map[0xc9e829d0810f1e3aD1d84C1aDb655678EDD6b901] = true;
_address_map[0xc9Ee5b6870D74F3fd1Ad903e7716bf576A806CB9] = true;
_address_map[0xC9fE451251398F7Ba82296DD6eC2E3f43ee8d93F] = true;
_address_map[0xcA1cBD87B41FDCd631b62dD9149aD47ff63B4019] = true;
_address_map[0xCA1F9fD2932881d73b72414C16e9364De8bb77D9] = true;
_address_map[0xca2788C15F43E762350A7894DDaeE10c3903510D] = true;
_address_map[0xca29916cADff6541cc05250b37cd2a8929c1Db44] = true;
_address_map[0xcA424E5Eb70caEaA36E3A9321284F54a59344cef] = true;
_address_map[0xcA4B3F39eC1bBec7eBF451Af86FB9321667d9Ed5] = true;
_address_map[0xCA7b7d80A8B40d1E2DF81AcC208bF4f6B8eEbCc8] = true;
_address_map[0xcA9736774e17cd8b70C1a7350FE9b72E7650621B] = true;
_address_map[0xca9d44E75bB08b5E8087FaC69f769e5FEa8bb293] = true;
_address_map[0xCaA5506764850C0145b24Ae7384e46846d6110A1] = true;
_address_map[0xCAb4161aE91900B9Cbd1A3C643a84dCb66F241BD] = true;
_address_map[0xCAC8219986bdF99Ec18849F5414CFA04a135da96] = true;
_address_map[0xCADe70a43Ce1f170D717aa139aaE3eb581aF5783] = true;
_address_map[0xcaE0fc8f06eDc6abd914eD3a700618d249C40ceb] = true;
_address_map[0xCb1758Ecdccb0a565af0d8CdAc8963A1DC90d6d2] = true;
_address_map[0xcB2695F9EAd1E66e8F7893a35Ebb240F85C0854c] = true;
_address_map[0xcb27C4a1B177A8d92fdeE300103D431b175079E1] = true;
_address_map[0xcB36fd9bF9E6bE4BB1af8E47dbF1f0E120f08435] = true;
_address_map[0xCb6a1FF7AabBE2AFCEB4f7C5A6eC7Ded94506C50] = true;
_address_map[0xCB70Dc414921f4588e14498D26D64e1c44a0857f] = true;
_address_map[0xcB7E2bFf70abe827DcDE8bF3fd52b3E04ca9733B] = true;
_address_map[0xCB899fCefC1E8175eCd29406FCF9dD484Ed46E6f] = true;
_address_map[0xcB96ba0031427D79bc9BF6162b85126E791F4A70] = true;
_address_map[0xCb999d13D45B11EA3F047f410d66d03Db126b92C] = true;
_address_map[0xCBbBEc0A13F58C3EB40B900F1c80Dc74463D6B3f] = true;
_address_map[0xcbc4526DB1f6119945Ca25966081a11494644B80] = true;
_address_map[0xCBC7312A6c87C1fb80d184A5449b197676AEAf27] = true;
_address_map[0xCbf5b6aE0cB9a57Eb4C45D0886C3d3764940675D] = true;
_address_map[0xCc04B9aaD232fE26E5690141Fcfd20D619E0cFd4] = true;
_address_map[0xCc319Ce8CE9fdDB53c528148fCe63Aa300ff2B91] = true;
_address_map[0xCc344eF03a8dD2DaEC5D825E06B7cDbc6b90D234] = true;
_address_map[0xcc35Ca2A5d989BD0FBf3c6ef17c260672695E0E0] = true;
_address_map[0xCC3851093d9C1d94D768E7F910E4136b28C2c631] = true;
_address_map[0xCC3c18D2ADE601C59A3711E2A753B806B919Cc55] = true;
_address_map[0xcc3cdB5d05c5AD9F3481e6abd5612473b99CA82D] = true;
_address_map[0xcC5a7686906307673Baa0E3c6022767638433CC7] = true;
_address_map[0xcc5b34901772D791069b069B5246222A62f7F16B] = true;
_address_map[0xcc5Dc6Ca37ecBb6CB68E795faFEDA37904A24115] = true;
_address_map[0xCc699670750814761c0A305d1d649de5b7898320] = true;
_address_map[0xcC8d41BDcF28E5c9b779BCd65efe067803DFB3E3] = true;
_address_map[0xcCA1E07Bcf9C4e747536a24801136C80B97aD9a3] = true;
_address_map[0xccCf610B1E95665D5173b6CEc89CE1B31388401c] = true;
    }

    //--------------------------------------
    // [external] 確認
    //--------------------------------------
    function check( address target ) external view override returns (bool) {
        return( _address_map[target] );
    }

}