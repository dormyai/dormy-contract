// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Interface/IPropertyDeed.sol";
import "./Interface/IPropertyManager.sol";
import "./Interface/IAccessControl.sol";
import "./lib/Strings.sol";
import "./lib/Base64.sol";

interface IERC3525 {

    function slotOf(uint256 _tokenId) external view returns (uint256);

    function balanceOf(uint256 _tokenId) external view returns (uint256);

}

/**
 * @title 生成房产证
 * @dev
 * @author 
 * @notice 
 */
contract PropertyDeed is IPropertyDeed {

    IPropertyManager public propertyManager;
    IAccessControl public accessControl;
    IERC3525 public dormy;

    constructor(address _accessControlAddress){
        accessControl = IAccessControl(_accessControlAddress);
    }

    modifier admin() {
        require(accessControl.isAdmin(msg.sender), "Only admin can call this");
        _;
    }

    function setPropertyManager(address propertyManagerAddress) public admin {
        propertyManager = IPropertyManager(propertyManagerAddress);
    }

    function setDormy(address dormyAddress) public admin {
        dormy = IERC3525(dormyAddress);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory json = Base64.encode(bytes(tokenURIJSON(tokenId)));
        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    function tokenURIJSON(uint256 tokenId) private view returns (string memory) {
        
        return string(
            abi.encodePacked(
                "{",
                '"name": "Dormy #',
                Strings.toString(tokenId),
                '",',
                '"image": "data:image/svg+xml;base64,',
                Base64.encode(abi.encodePacked(_getSVGHeader(),_getSVGDefs(),_getSVGMainContent(tokenId),_getSVGFooter())),
                '"}'
            )
        );
    }

    function _getSVGHeader() private pure returns (string memory) {
        return '<?xml version="1.0" encoding="UTF-8"?><svg width="490px" height="692px" viewBox="0 0 490 692" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><title>Property Deed</title>';
    }

    function _getSVGDefs() private pure returns (string memory) {
        // This function returns the SVG definitions and background setup
        return '<g id="tdb" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><rect fill="#FFFFFF" x="0" y="0" width="490" height="692"></rect><rect id="bjls" fill="#3B5CFF" x="8" y="8" width="474" height="676"></rect><rect id="bjb" fill="#FFFFFF" x="18" y="18" width="454" height="656"></rect>';
    }

    function _getSVGMainContent(uint256 tokenId) private view returns (string memory) {
        return string(abi.encodePacked(
            _getSVGTitleAndDeed(),
            _getSVGPropertyDetails(tokenId),
            _getSVGOwnershipDetails(tokenId),
            _getSVGOnChainInfo(tokenId)
        ));
    }

    function _getSVGTitleAndDeed() private pure returns (string memory) {
        // Returns the title and deed part of the SVG
        return string(abi.encodePacked(
            '        <g id="Slice-1" transform="translate(38.000000, 38.000000)" fill="#3B5CFF"><path d="M5.81402515,5.88524333 L1.14488953,9.0524777 L1.14488953,5.63347549 L1.14488953,0.0258456426 C1.14488953,0.0258456426 1.54179158,0.0262967088 1.67926041,0.0263244058 C3.59010147,0.0268236407 5.50095465,0.0244112454 7.41177318,0.0299847164 C7.84998867,0.0312324596 8.28480687,0.0781213183 8.7197984,0.148302359 C9.29255343,0.240721717 9.84738603,0.39367133 10.3798416,0.612201005 C11.0628525,0.892536376 11.6967934,1.26726017 12.2659085,1.74745982 C13.0883122,2.44136539 13.7147651,3.28337272 14.1467234,4.27105618 C14.4117638,4.87701933 14.5880935,5.5078066 14.6763363,6.1673059 C14.7229797,6.5160306 14.7433808,6.86492734 14.7562592,7.2139445 C14.7713737,7.62375753 14.7381635,8.03386301 14.6874295,8.44154285 C14.6516713,8.72881796 14.6050279,9.01516411 14.5291089,9.293528 C14.4092159,9.73298203 14.2645018,10.1640237 14.0628312,10.5751442 C13.8004253,11.1100584 13.4849282,11.6072289 13.1023,12.0629743 C12.6958907,12.5470361 12.2302196,12.9623197 11.7113358,13.318631 C11.1388061,13.7117742 10.5219904,14.0190049 9.86549913,14.2354892 C9.38294556,14.3946181 8.88806816,14.5064213 8.38076292,14.5740124 C7.71537979,14.6626946 7.04935534,14.6710209 6.38144158,14.6710897 C4.69513873,14.6713477 1.14488953,14.6743411 1.14488953,14.6743411 L1.14488953,11.1903798 L3.93067959,9.29003576 L3.93067959,12.2197293 C3.93067959,12.2197293 6.4977987,12.2127964 7.725121,12.1824329 C8.20330662,12.1705971 8.67121372,12.0351397 9.12194371,11.8449418 C9.71005587,11.5967694 10.2237917,11.2494554 10.6618338,10.7868287 C11.0291396,10.3989325 11.3062439,9.95122097 11.5212264,9.4604672 C11.6987174,9.05535063 11.8139305,8.63229119 11.8712684,8.19780886 C11.9205291,7.82455249 11.9557153,7.44689212 11.9136478,7.06665127 C11.8848575,6.80633347 11.8829682,6.54482865 11.826965,6.2853538 C11.7605099,5.97714247 11.6847122,5.67226855 11.5660845,5.38217212 C11.3912801,4.95469148 11.1609579,4.55793562 10.8735924,4.19417538 C10.4522766,3.66089547 9.93124358,3.25663905 9.32692497,2.96100321 C8.79044813,2.69855222 8.22258103,2.5529449 7.62618365,2.50284938 C7.32363435,2.47742315 7.02240237,2.47802526 6.72054639,2.47707909 C5.84073546,2.47425778 3.93067959,2.4804509 3.93067959,2.4804509 L3.93067959,4.34121056 L5.8198664,3.14228983 C5.8198664,3.14228983 7.9922241,4.61788854 9.03042493,5.33407216 C9.48661485,5.64878627 10.4439221,6.32074064 10.4439221,6.32074064 L10.4439221,9.0524777 L5.81402515,5.88524333 Z" id="lj"></path>',
            '            <polygon id="lj" points="5.83501553 3.1157626 0 6.89233193 0 9.86780298 5.83501553 5.86236317"></polygon><rect id="jx" fill-rule="nonzero" x="4.87167638" y="8.14186428" width="1" height="1"></rect>',
            '            <rect id="jx" fill-rule="nonzero" x="4.87167638" y="9.25039975" width="1" height="1"></rect><rect id="jx" fill-rule="nonzero" x="5.97061239" y="8.14186428" width="1" height="1"></rect><rect id="jx" fill-rule="nonzero" x="5.97061239" y="9.25039975" width="1" height="1"></rect>',
            '            <polygon id="lj" fill-rule="nonzero" points="87.7829762 14.5777455 87.7829762 0 91 0 91 14.5777455"></polygon><path d="M82.9234677,14.5777455 L81.674791,10.9648124 L75.7066572,10.9648124 L74.4366608,14.5777455 L71.0927588,14.5777455 L76.5743523,0 L80.8918548,0 L86.3309823,14.5777455 L82.9234677,14.5777455 Z M76.6377915,8.31812757 L80.7436568,8.31812757 L78.8389221,2.79371995 L78.5848189,2.79371995 L76.6377915,8.31812757 Z" id="xz" fill-rule="nonzero"></path>',
            '            <path d="M59.99992,19 L59.99992,16.2360587 C62.0271996,16.2360587 62.7624698,15.6832876 63.1188384,14.4671809 L58.4404608,2.63784236 L62.0271996,2.63784236 L64.8566552,11.1505374 L64.9902935,11.1505374 L67.6635778,2.63784236 L71.1390381,2.63784236 L67.1066652,13.4721862 C65.50266,17.7395265 64.2104772,19 59.99992,19 Z" id="lj" fill-rule="nonzero"></path><path d="M53.3225157,2.4167305 C56.0181598,2.4167305 57.3325289,3.67704921 57.3325289,6.66203359 L57.3325289,14.5777455 L54.1021586,14.5777455 L54.1021586,7.25901671 C54.1021586,5.64491557 53.6343382,5.02580923 52.275423,5.02580923 C50.9610539,5.02580923 50.2705031,5.51226221 49.9808669,6.77258092 L49.9808669,14.5777455 L46.7504967,14.5777455 L46.7504967,7.25901671 C46.7504967,5.64491557 46.2826762,5.02580923 44.9683071,5.02580923 C43.6315782,5.02580923 43.0746657,5.46803296 42.7404835,6.63991036 L42.7404835,14.5777455 L39.5101132,14.5777455 L39.5101132,2.63784236 L42.7404835,2.63784236 L42.7404835,3.98660238 C43.3864882,2.92527231 44.4335809,2.4167305 46.1266783,2.4167305 C47.9312276,2.4167305 49.0228664,2.96950156 49.5575926,4.09714971 C50.2035973,2.88106026 51.5403261,2.4167305 53.3225157,2.4167305 Z" id="lj" fill-rule="nonzero"></path>',
            '            <path d="M37.5192331,2.4167305 L37.7643231,2.4167305 L37.675231,5.26902712 L37.3632352,5.26902712 C35.8706817,5.26902712 34.3781283,5.84392141 34.0215864,7.78968174 L34.0215864,14.5777455 L30.7913894,14.5777455 L30.7913894,2.63784236 L34.0215864,2.63784236 L34.0215864,4.78259134 C34.7344969,2.81472498 36.0934121,2.4167305 37.5192331,2.4167305 Z" id="lj" fill-rule="nonzero"></path>',
            '            <path d="M22.5007933,14.7988401 C18.7580566,14.7988401 16.5970867,13.4500801 16.5970867,8.60779392 C16.5970867,3.76549052 18.7580566,2.4167305 22.5007933,2.4167305 C26.2211704,2.4167305 28.3820882,3.76549052 28.3820882,8.60779392 C28.3820882,13.4500801 26.2211704,14.7988401 22.5007933,14.7988401 Z M22.5007933,12.366644 C24.4835269,12.366644 25.0849855,11.5264258 25.0849855,8.60779392 C25.0849855,5.71125085 24.4389808,4.80471456 22.5007933,4.80471456 C20.5180598,4.80471456 19.9164278,5.71125085 19.9164278,8.60779392 C19.9164278,11.5264258 20.5626058,12.366644 22.5007933,12.366644 Z" id="xz" fill-rule="nonzero"></path>',
            '        </g>'));
    }

    function _getSVGPropertyDetails(uint256 tokenId) private view returns (string memory) {

        uint256 slotId = dormy.slotOf(tokenId);
        IProperty property = propertyManager.getPropertyInfoBySolt(slotId);
        IProperty.PropertyLocationData memory pld = property.getPropertyLocation();

        return string(abi.encodePacked(
            '<text id="HM-Land-Registry-Rec" font-family="Helvetica-Bold, Helvetica" font-size="16" font-weight="bold" fill="#3A3942"><tspan x="38" y="151">HM Land Registry Record:</tspan></text>',
            '        <text id="Fractional-Title-Dee" font-family="Times-Roman, Times" font-size="24" font-weight="normal" fill="#0C345D" text-decoration="underline">',
            '            <tspan x="92" y="100">FRACTIONAL</tspan><tspan x="244.003906" y="100" font-family="Mshtakan"> </tspan><tspan x="256.003906" y="100">TITLE</tspan><tspan x="322.636719" y="100" font-family="Mshtakan"> </tspan>',
            '            <tspan x="334.636719" y="100">DEED</tspan>',
            '        </text>',
            '<text id="Summerlee-Avenue,Eas" font-family="Helvetica" font-size="14" font-weight="normal" fill="#3A3942"><tspan x="38" y="175">',pld.address1,',',pld.address2,'</tspan></text>'
        ));
    }

    function _getSVGOwnershipDetails(uint256 tokenId) private view returns (string memory) {

        uint256 slotId = dormy.slotOf(tokenId);
        uint256 balance = dormy.balanceOf(tokenId);

        IProperty property = propertyManager.getPropertyInfoBySolt(slotId);
        IProperty.InvestmentValue memory iv = property.getInvestmentValue();

        return string(abi.encodePacked(
            '        <text id="This-property-is-tok" font-family="Helvetica" font-size="14" font-weight="normal" line-spacing="22"><tspan x="67.7871094" y="327" fill="#3A3942">This property is tokenized through blockchain technology. </tspan><tspan x="53.0009766" y="349" fill="#3A3942">Each token holder will get a digital title deed, which represents</tspan><tspan x="106.375977" y="371" font-family="Helvetica-Bold, Helvetica" font-weight="bold" fill="#FF3710">Your fractional ownership of the property.</tspan></text><text id="This-Title-Deed-decr" font-family="Helvetica" font-size="14" font-weight="normal" line-spacing="22" fill="#049E4D"><tspan x="41.1665039" y="413">This Title Deed decrees the holder have the following ownership </tspan><tspan x="125.59375" y="435">of the property now and in the future.</tspan></text>',
            '        <rect id="bjkl" fill="#049E4D" opacity="0.0634227934" x="38" y="453" width="414" height="69" rx="4"></rect><text id="Owned-Size-:-1-Sq.Ft" font-family="Helvetica" font-size="12" font-weight="normal" line-spacing="12"><tspan x="50" y="504" fill="#3A3942">Owned Size :</tspan><tspan x="123.898438" y="505.910156" font-family="Helvetica-Bold, Helvetica" font-weight="bold" fill="#049E4D"> -- Sq.Ft</tspan></text><text id="Token-Amount-:-1-DSF" font-family="Helvetica" font-size="12" font-weight="normal" line-spacing="12"><tspan x="50" y="481" fill="#3A3942">Token Amount :</tspan><tspan x="137.240234" y="482.910156" font-family="Helvetica-Bold, Helvetica" font-weight="bold" fill="#049E4D">',Strings.toString(balance),' </tspan></text>',
            '        <text id="Value-:-$200" font-family="Helvetica" font-size="12" font-weight="normal" line-spacing="12"><tspan x="359" y="481" fill="#3A3942">    Value :</tspan><tspan x="409.695312" y="481" fill="#049E4D"> </tspan><tspan x="412.226562" y="482.910156" font-family="Helvetica-Bold, Helvetica" font-weight="bold" fill="#049E4D">$',Strings.toString(iv.tokenPrice * balance / 10 ** 18),
            '</tspan></text><text id=".Ownership%-:-0.067%" font-family="Helvetica" font-size="12" font-weight="normal" line-spacing="12"><tspan x="317" y="504" fill="#3A3942">.Ownership : </tspan><tspan x="397.560547" y="505.910156" font-family="Helvetica-Bold, Helvetica" font-weight="bold" fill="#049E4D">',Strings.toString(balance),'/',Strings.toString(iv.tokenAmount),'</tspan></text>'
        ));
    }

    function _getSVGOnChainInfo(uint256 tokenId) private view returns (string memory) {
        
        uint256 slotId = dormy.slotOf(tokenId);
        IProperty property = propertyManager.getPropertyInfoBySolt(slotId);
        IProperty.PropertyLocationData memory location = property.getPropertyLocation();

        // IProperty.InvestmentValue memory iv = property.getInvestmentValue();
        // Strings.toHexString(uint160(address(property)), 20)
        return string(abi.encodePacked(
            '        <text id="On-Chain-information" font-family="Helvetica-Bold, Helvetica" font-size="14" font-weight="bold" fill="#3A3942"><tspan x="38.730957" y="550">On-Chain information:</tspan></text><text id="Contract-Address" font-family="Helvetica" font-size="14" font-weight="normal" line-spacing="14" fill="#64636D"><tspan x="38" y="580">Contract Address</tspan></text><text id="Token-ID" font-family="Helvetica" font-size="14" font-weight="normal" line-spacing="14" fill="#64636D"><tspan x="38" y="602">Token ID</tspan></text><text id="Token-Standard" font-family="Helvetica" font-size="14" font-weight="normal" line-spacing="14" fill="#64636D"><tspan x="38" y="624">Token Standard</tspan></text><text id="Chain" font-family="Helvetica" font-size="14" font-weight="normal" line-spacing="14" fill="#64636D"><tspan x="38" y="646">Chain</tspan></text><text id="addr" font-family="Helvetica" font-size="14" font-weight="normal" line-spacing="14" fill="#2C6EB2"><tspan x="363" y="580">',
                    formatAddress(address(property)),'</tspan></text><text id="tokenId" font-family="Helvetica" font-size="14" font-weight="normal" line-spacing="14" fill="#3A3942"><tspan x="428" y="602">',
                    Strings.toString(tokenId),'</tspan></text><text id="ERC3525" font-family="Helvetica" font-size="14" font-weight="normal" line-spacing="14" fill="#3A3942"><tspan x="391" y="624">ERC3525</tspan></text><text id="chain" font-family="Helvetica" font-size="14" font-weight="normal" line-spacing="14" fill="#3A3942"><tspan x="391" y="646">BLAST</tspan></text><rect id="bjk" fill="#F0F2FF" x="38" y="198" width="414" height="97" rx="4"></rect><text id="Registry-No.:-AV1023" font-family="Helvetica" font-size="12" font-weight="normal" line-spacing="11"><tspan x="50" y="225" fill="#3A3942">Registry No.:</tspan><tspan x="119.351562" y="225" fill="#64636D"> </tspan><tspan x="122.685547" y="225" fill="#394CCA">AV102307</tspan></text><text id="Bedrooms:-3" font-family="Helvetica" font-size="12" font-weight="normal" line-spacing="11"><tspan x="50" y="252" fill="#3A3942">Bedrooms: </tspan><tspan x="111.359375" y="252" fill="#394CCA">3</tspan></text><text id="Type:-Semi-detached" font-family="Helvetica" font-size="12" font-weight="normal" line-spacing="11"><tspan x="50" y="279" fill="#3A3942">Type: </tspan><tspan x="83.3457031" y="279" fill="#394CCA">Semi-detached</tspan></text><text id="Tenure:-Freehold" font-family="Helvetica" font-size="12" font-weight="normal" line-spacing="11"><tspan x="210" y="279" fill="#3A3942">Tenure: </tspan><tspan x="254.689453" y="279" fill="#394CCA">Freehold</tspan></text><text id="Bathrooms:-2" font-family="Helvetica" font-size="12" font-weight="normal" line-spacing="11"><tspan x="210" y="252" fill="#3A3942">Bathrooms: </tspan><tspan x="274.693359" y="252" fill="#394CCA">2</tspan></text><text id="Size:-1,500-Sq.-Ft" font-family="Helvetica" font-size="12" font-weight="normal" line-spacing="11"><tspan x="341" y="252" fill="#3A3942">Size: </tspan><tspan x="371.011719" y="252" fill="#394CCA">1,500 Sq. Ft </tspan></text>',
            '        <text id="city" font-family="Helvetica" font-size="12" font-weight="normal" line-spacing="11"><tspan x="210" y="225" fill="#3A3942">City: </tspan><tspan x="237.333984" y="225" fill="#394CCA">', location.city,
            '</tspan></text><text id="Postcode:-N2-3DP" font-family="Helvetica" font-size="12" font-weight="normal" line-spacing="11"><tspan x="341" y="225" fill="#3A3942">Postcode: </tspan><tspan x="397.701172" y="225" fill="#394CCA">',location.postalCode,'</tspan></text></g>'
        ));
    }

    function _getSVGFooter() private pure returns (string memory) {
        return '</svg>';
    }

    function formatAddress(address _addr) private pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";

        bytes20 value = bytes20(_addr);
        bytes memory str = new bytes(42); // 2 + 20 * 2
        str[0] = '0';
        str[1] = 'x';
        for (uint256 i = 0; i < 20; i++) {
            str[2+i*2] = alphabet[uint256(uint8(value[i] >> 4))];
            str[3+i*2] = alphabet[uint256(uint8(value[i] & 0x0f))];
        }

        // Keeping the first 4 and last 4 characters now
        return string(abi.encodePacked(substring(str, 0, 6), "...", substring(str, 38, 42)));
    }

    function substring(bytes memory str, uint startIndex, uint endIndex) private pure returns (bytes memory) {
        bytes memory result = new bytes(endIndex-startIndex);
        for(uint i = startIndex; i < endIndex; i++) {
            result[i-startIndex] = str[i];
        }
        return result;
    }
}