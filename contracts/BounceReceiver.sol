pragma ever-solidity >= 0.61.2;

pragma AbiHeader expire;
pragma AbiHeader pubkey;

import "./BounceProducer.sol";
import "./lib/CommonStructures.sol";

import "locklift/src/console.sol";


contract BounceReceiver {
    constructor() public {
        tvm.accept();
    }
    uint128 constant MIN_CONTRACT_BALANCE = 0.1 ever;
    TvmCell static bounceProducerCode;
    address static owner;
    uint128 static nonce;
    BounceProducer bounceProducer;

    function _reserve() internal pure returns (uint128) {
        return math.min(address(this).balance - msg.value, MIN_CONTRACT_BALANCE);
    }


    function deployBounceProducer(uint128 nonce) public {
        tvm.rawReserve(_reserve(), 0);

        bounceProducer = BounceProducer(
            new BounceProducer{
                stateInit: tvm.buildStateInit({
                    contr: BounceProducer,
                    varInit: {
                        nonce: nonce
                    },
                    pubkey: 0,
                    code: bounceProducerCode
                }),
                value: 0,
                flag: 128
            }()
        );

    }

    function fiveUInts(uint128 a, uint128 b, uint128 c, uint128 d, uint128 e) public {
        tvm.rawReserve(_reserve(), 0);
        bounceProducer.fiveUInts{value: 0, flag: 128, bounce: true}(a, b, c, d, e);
    }

    function handleFiveUInts(TvmSlice _slice) internal {
        tvm.rawReserve(_reserve(), 0);
        (uint128 a, uint128 b, uint128 c, uint128 d, uint128 e) = _slice.decodeFunctionParams(BounceProducer.fiveUInts);

        emit FiveUInts(a, b, c, d, e);
        owner.transfer({value: 0, flag: 128, bounce: false});
    }
    event FiveUInts(uint128 a, uint128 b, uint128 c, uint128 d, uint128 e);

    function fiveStrings(string a, string b, string c, string d, string e) public {
        tvm.rawReserve(_reserve(), 0);
        bounceProducer.fiveStrings{value: 0, flag: 128, bounce: true}(a, b, c, d, e);
    }
    function handleFiveStrings(TvmSlice _slice) internal {
        tvm.rawReserve(_reserve(), 0);
        (string a, string b, string c, string d, string e) = _slice.decodeFunctionParams(BounceProducer.fiveStrings);
        emit FiveStrings(a, b, c, d, e);
        owner.transfer({value: 0, flag: 128, bounce: false});

    }
    event FiveStrings(string a, string b, string c, string d, string e);

    function fiveUIntsArrayMaps(
        mapping(uint128 => uint128[]) a,
        mapping(uint128 => uint128[]) b,
        mapping(uint128 => uint128[]) c,
        mapping(uint128 => uint128[]) d,
        mapping(uint128 => uint128[]) e
    ) public {
        tvm.rawReserve(_reserve(), 0);
        bounceProducer.fiveMapsOfUIntsArr{value: 0, flag: 128, bounce: true}(a, b, c, d, e);
    }

    function handleFiveUIntsArrayMaps(TvmSlice _slice) internal {
        tvm.rawReserve(_reserve(), 0);
        (
            mapping(uint128 => uint128[]) a,
            mapping(uint128 => uint128[]) b,
            mapping(uint128 => uint128[]) c,
            mapping(uint128 => uint128[]) d,
            mapping(uint128 => uint128[]) e
        ) = _slice.decodeFunctionParams(BounceProducer.fiveMapsOfUIntsArr);
        emit FiveUIntsArrayMaps(a, b, c, d, e);
        owner.transfer({value: 0, flag: 128, bounce: false});
    }

    event FiveUIntsArrayMaps(
        mapping(uint128 => uint128[]) a,
        mapping(uint128 => uint128[]) b,
        mapping(uint128 => uint128[]) c,
        mapping(uint128 => uint128[]) d,
        mapping(uint128 => uint128[]) e
    );

    function fiveHugeMaps(
        mapping(uint128 => CommonStructures.UIntStringMap[]) a,
        mapping(uint128 => CommonStructures.UIntStringMap[]) b,
        mapping(uint128 => CommonStructures.UIntStringMap[]) c,
        mapping(uint128 => CommonStructures.UIntStringMap[]) d,
        mapping(uint128 => CommonStructures.UIntStringMap[]) e
    ) public {
        tvm.rawReserve(_reserve(), 0);
        bounceProducer.fiveHugeMaps{value: 0, flag: 128, bounce: true}(a, b, c, d, e);
    }

    function handleFiveHugeMaps(TvmSlice _slice) internal {
        tvm.rawReserve(_reserve(), 0);
        (
            mapping(uint128 => CommonStructures.UIntStringMap[]) a,
            mapping(uint128 => CommonStructures.UIntStringMap[]) b,
            mapping(uint128 => CommonStructures.UIntStringMap[]) c,
            mapping(uint128 => CommonStructures.UIntStringMap[]) d,
            mapping(uint128 => CommonStructures.UIntStringMap[]) e
        ) = _slice.decodeFunctionParams(BounceProducer.fiveHugeMaps);
        emit FiveHugeMaps(a, b, c, d, e);
        owner.transfer({value: 0, flag: 128, bounce: false});
    }

    event FiveHugeMaps(
        mapping(uint128 => CommonStructures.UIntStringMap[]) a,
        mapping(uint128 => CommonStructures.UIntStringMap[]) b,
        mapping(uint128 => CommonStructures.UIntStringMap[]) c,
        mapping(uint128 => CommonStructures.UIntStringMap[]) d,
        mapping(uint128 => CommonStructures.UIntStringMap[]) e
    );



    onBounce(TvmSlice _slice) external {
        tvm.accept();
        TvmSlice newSlice = _slice.loadRef().toSlice();
        uint32 functionId = newSlice.decode(uint32);
        if (functionId == tvm.functionId(BounceProducer.fiveUInts)) {
            handleFiveUInts(newSlice);
            return;
        }
        if (functionId == tvm.functionId(BounceProducer.fiveStrings)) {
            handleFiveStrings(newSlice);
            return;
        }
        if (functionId == tvm.functionId(BounceProducer.fiveMapsOfUIntsArr)) {
            handleFiveUIntsArrayMaps(newSlice);
            return;
        }
        if (functionId == tvm.functionId(BounceProducer.fiveHugeMaps)) {
            handleFiveHugeMaps(newSlice);
            return;
        }

    }

}
