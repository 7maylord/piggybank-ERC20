import { loadFixture, time } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

describe("PiggyBank (ERC-20 Version)", function () {
    async function deployPiggyBankContract() {
        const [manager, contributor1, contributor2, stranger] = await hre.ethers.getSigners();
        const Token = await hre.ethers.getContractFactory("MayToken");
        const token = await Token.deploy("MayToken", "MTK", 18, hre.ethers.parseUnits("1000000"));

        const PiggyBank = await hre.ethers.getContractFactory("PiggyBank");
        const withdrawalDate = (await time.latest()) + 60 * 60 * 24; // 1 day from now
        const targetAmount = hre.ethers.parseEther("100");
        const piggyBank = await PiggyBank.deploy(targetAmount, withdrawalDate, token.target, manager.address);

        return { piggyBank, token, manager, contributor1, contributor2, stranger, targetAmount, withdrawalDate };
    }

    describe("Deployment", function () {
        it("should be deployed correctly", async function () {
            const { piggyBank, manager, token } = await loadFixture(deployPiggyBankContract);
            expect(await piggyBank.manager()).to.equal(manager.address);
            expect(await piggyBank.token()).to.equal(token.target);
        });
    });

    describe("Saving tokens", function () {
        it("should allow contributors to deposit tokens", async function () {
            const { piggyBank, token, contributor1 } = await loadFixture(deployPiggyBankContract);
            const depositAmount = hre.ethers.parseUnits("50", 18);

            await token.connect(contributor1).approve(piggyBank.target, depositAmount);
            await expect(piggyBank.connect(contributor1).save(depositAmount))
                .to.emit(piggyBank, "Contributed")

            expect(await piggyBank.contributions(contributor1.address)).to.equal(depositAmount);
        });
    });

    // describe("Withdrawals", function () {
    //     it("should allow the manager to withdraw after the withdrawal date", async function () {
    //         const { piggyBank, token, contributor1, manager, targetAmount, withdrawalDate } = await loadFixture(deployPiggyBankContract);
    //         const depositAmount = hre.ethers.parseEther("100");
            
    //         await token.connect(contributor1).approve(piggyBank.target, depositAmount);
    //         await piggyBank.connect(contributor1).save(depositAmount);
    //         await time.increaseTo(withdrawalDate);
            
    //         await expect(piggyBank.connect(manager).withdrawal())
    //             .to.emit(piggyBank, "Withdrawn")
            
    //         expect(await token.balanceOf(manager.address)).to.equal(targetAmount);
    //     });
    // });
});
