// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./DefioneToken.sol";


contract DefioneBridge is ReentrancyGuard {
	IERC20 public defioneV1;
	DefioneToken public defioneV2;
	address public burnAddress = 0xdEad000000000000000000000000000000000000;

	constructor(IERC20 _defioneV1, DefioneToken _defioneV2) public {
		defioneV1 = _defioneV1;
		defioneV2 = _defioneV2;
	}

	event Bridge(address indexed user, uint amount);

	function convert(uint256 _amount) public nonReentrant {
		require(msg.sender == tx.origin, "Must be called directly");

		bool success = false;

		success = defioneV1.transferFrom(msg.sender, burnAddress, _amount);

		require(success == true, 'transfer failed');

		defioneV2.bridgeMint(msg.sender, _amount);
		emit Bridge(msg.sender, _amount);
		
	}
}