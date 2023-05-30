// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";

import {Utils} from "./Utils.sol";

import {GuessTheNumber, ISolver} from "src/gas-optis/g05-solver/Common.sol";
import {Solver as Reference} from "src/gas-optis/g05-solver/Reference.sol";
import {Solver as Optimized} from "src/gas-optis/g05-solver/Optimized.sol";

contract TestSolver is Test, Utils {
    ISolver ref;
    ISolver opti;

    function setUp() public {
        ref = new Reference();
        opti = new Optimized();
    }

    function testSolver(uint256 solution) public {
        GuessTheNumber game = new GuessTheNumber(solution);
        assertEq(opti.solve(game), solution);
    }

    function testGasSolver() public {
        uint256 refGas = 0;
        uint256 optiGas = 0;
        bytes memory data;

        data = abi.encodeWithSelector(ref.solve.selector, new GuessTheNumber(uint256(keccak256("testGasSolver.1"))));
        refGas += callGasUsage(address(ref), 0, data);
        optiGas += callGasUsage(address(opti), 0, data);

        data = abi.encodeWithSelector(ref.solve.selector, new GuessTheNumber(uint256(keccak256("testGasSolver.2"))));
        refGas += callGasUsage(address(ref), 0, data);
        optiGas += callGasUsage(address(opti), 0, data);

        data = abi.encodeWithSelector(ref.solve.selector, new GuessTheNumber(uint256(keccak256("testGasSolver.3"))));
        refGas += callGasUsage(address(ref), 0, data);
        optiGas += callGasUsage(address(opti), 0, data);

        printGasResult(refGas, 18000000, 17836345, optiGas);
    }
}
