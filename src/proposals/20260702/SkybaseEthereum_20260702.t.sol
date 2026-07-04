// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.25;

import { IERC20 } from "forge-std/interfaces/IERC20.sol";

import { Ethereum } from "skybase-address-registry/Ethereum.sol";

import { ChainIdUtils } from "src/libraries/ChainId.sol";

import { SkybaseTestBase } from "src/test-harness/SkybaseTestBase.sol";

import { SkybaseEthereum_20260702 as SkybaseSpell } from "./SkybaseEthereum_20260702.sol";

contract SkybaseEthereum_20260702Test is SkybaseTestBase {
    
    SkybaseSpell internal SKYBASE_SPELL;
    address internal DEPLOYER;
    
    address internal sender = Ethereum.SKYBASE_PROXY;

    constructor() {
        id = "20260702";
    }

    function _setupAddresses() internal virtual {
        DEPLOYER      = 0x25BaDaA3379ecbc0231be30A3d72F1BEB8eD1009;
        SKYBASE_SPELL = SkybaseSpell(0xd3e4e16ED515Be794fd181D7d2cEB0447A6f2cb5);
    }

    function setUp() public {
        // June 25, 2026
        setupMainnetDomain(25_397_676);
        _setupAddresses();

        chainData[ChainIdUtils.Ethereum()].payload = address(SKYBASE_SPELL);
    }

    function test_usdsTransfer() public {
        SkybaseSpell spell = SkybaseSpell(chainData[ChainIdUtils.Ethereum()].payload);

        address recipient = Ethereum.SKYBASE_FOUNDATION_OPERATIONAL_MULTISIG;
        uint256 amount    = spell.USDS_TRANSFER_AMOUNT();

        uint256 recipientBalanceBefore = IERC20(Ethereum.USDS).balanceOf(recipient);
        uint256 proxyBalanceBefore     = IERC20(Ethereum.USDS).balanceOf(sender);

        assertGe(proxyBalanceBefore, amount, "insufficient-skybase-proxy-usds-balance");
        _assertSkybaseProxyUsdsBalance(proxyBalanceBefore);

        executeMainnetPayload();

        assertEq(
            IERC20(Ethereum.USDS).balanceOf(recipient),
            recipientBalanceBefore + amount,
            "incorrect-recipient-usds-balance"
        );
        _assertSkybaseProxyUsdsBalance(proxyBalanceBefore - amount);
    }
}
