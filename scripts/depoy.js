const { ethers } = require("hardhat");

async function main() {
  // 1. Deploy the OpWorldID contract with a placeholder address
  const OpWorldID = await ethers.getContractFactory("OpWorldID");
  const opWorldID = await OpWorldID.deploy(
    "0x0000000000000000000000000000000000000000"
  ); // Placeholder address
  await opWorldID.waitForDeployment();
  console.log("OpWorldID deployed to:", opWorldID.address);

  // 2. Deploy the L2Messenger contract with a placeholder address for l2Contract
  const L2Messenger = await ethers.getContractFactory("L2Messenger");
  const l2Messenger = await L2Messenger.deploy(
    "0x0000000000000000000000000000000000000000"
  ); // Placeholder address
  await l2Messenger.waitForDeployment();
  console.log("L2Messenger deployed to:", l2Messenger.address);

  // 3. Deploy the OpStateBridge contract with a placeholder address for target L2 contract
  const OpStateBridge = await ethers.getContractFactory("OpStateBridge");
  const worldIDIdentityManagerAddress = "0xYourWorldIDIdentityManagerAddress"; // Replace with actual address
  const opStateBridge = await OpStateBridge.deploy(
    worldIDIdentityManagerAddress
  );
  await opStateBridge.waitForDeployment();
  console.log("OpStateBridge deployed to:", opStateBridge.address);

  // 4. Set the correct addresses now that all contracts are deployed

  // Set the L2Messenger address in OpWorldID
  await opWorldID.setL2Messenger(l2Messenger.address);
  console.log("OpWorldID L2Messenger address updated to:", l2Messenger.address);

  // Set the OpWorldID address in L2Messenger
  await l2Messenger.setL2Contract(opWorldID.address);
  console.log("L2Messenger l2Contract address updated to:", opWorldID.address);

  // Set the OpWorldID address in OpStateBridge as the target L2 contract
  await opStateBridge.setTargetL2Contract(opWorldID.address);
  console.log("OpStateBridge target L2 contract set to:", opWorldID.address);

  console.log("All contracts deployed and linked successfully!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
