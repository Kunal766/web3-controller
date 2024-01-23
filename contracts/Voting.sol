// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// contracts/Voting.sol
contract Voting {
    address public admin;
    uint256 public totalVotes;
    bool public votingClosed;

    enum VoteOption { Option1, Option2, Option3 }

    mapping(address => VoteOption) public votes;
    mapping(VoteOption => uint256) public voteCounts;

    event Voted(address indexed voter, VoteOption option);
    event VotingClosed(VoteOption winner);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    modifier onlyOpenVoting() {
        require(!votingClosed, "Voting is closed");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function vote(VoteOption option) external onlyOpenVoting {
        require(option >= VoteOption.Option1 && option <= VoteOption.Option3, "Invalid option");

        votes[msg.sender] = option;
        voteCounts[option]++;
        totalVotes++;

        emit Voted(msg.sender, option);
    }

    function closeVoting() external onlyAdmin {
        votingClosed = true;
        revealWinner();
    }

    function revealWinner() internal {
        require(votingClosed, "Voting is not closed yet");

        VoteOption winner;
        uint256 maxVotes = 0;

        for (uint8 i = uint8(VoteOption.Option1); i <= uint8(VoteOption.Option3); i++) {
            VoteOption option = VoteOption(i);
            if (voteCounts[option] > maxVotes) {
                maxVotes = voteCounts[option];
                winner = option;
            }
        }

        emit VotingClosed(winner);
    }
}
