// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.25;

import { Ethereum } from "lib/skybase-address-registry/src/Ethereum.sol";

import { SkybasePayloadEthereum } from "src/libraries/SkybasePayloadEthereum.sol";

interface IERC20Like {
    function transfer(address to, uint256 amount) external returns (bool);
}

/**
 * @title   July 02, 2026 Skybase Ethereum Proposal
 * @author  Soter Labs
 * @notice  Transfer Skybase Foundation Grant
 * Forum Post: https://forum.skyeco.com/t/july-2-2026-proposed-changes-to-skybase-for-upcoming-spell/27973
 * Vote Link:  https://vote.sky.money/polling/QmdXjfm6
 */
contract SkybaseEthereum_20260702 is SkybasePayloadEthereum {

    // Skybase Foundation operational grant: 700,000 USDS (USDS has 18 decimals)
    uint256 public constant USDS_TRANSFER_AMOUNT = 700_000e18;

    function _execute() internal override {
        // Transfer the grant from the Skybase Proxy to the Skybase Foundation Operational Multisig
        // Forum Post: https://forum.skyeco.com/t/july-2-2026-proposed-changes-to-skybase-for-upcoming-spell/27973
        // Vote Link:  https://vote.sky.money/polling/QmdXjfm6
        _transferFoundationGrant();
    }

    function _transferFoundationGrant() private {
        require(IERC20Like(Ethereum.USDS).transfer(Ethereum.SKYBASE_FOUNDATION_OPERATIONAL_MULTISIG, USDS_TRANSFER_AMOUNT));
    }
}
