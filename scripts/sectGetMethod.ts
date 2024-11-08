import { Address, toNano } from '@ton/core';
import { Taoists } from '../wrappers/Taoists';
import { NetworkProvider, sleep } from '@ton/blueprint';
import { Sect } from '../build/Taoists/tact_Sect';

export async function run(provider: NetworkProvider, args: string[]) {
    const ui = provider.ui();

    const taoistsAddress = Address.parse(args.length > 0 ? args[0] : await ui.input('Taoists address'));

    if (!(await provider.isContractDeployed(taoistsAddress))) {
        ui.write(`Error: Contract at address ${taoistsAddress} is not deployed!`);
        return;
    }
    const taoistsContract = provider.open(Taoists.fromAddress(taoistsAddress));
    const sectId = await ui.input('Sect ID: ');
    const sectAddress = await taoistsContract.getClanAddress(BigInt(sectId));
    console.log('sectAddress', sectAddress);
    if (!(await provider.isContractDeployed(sectAddress))) {
        ui.write(`Error: Sect Contract at address ${sectAddress} is not deployed!`);
        return;
    }

    const sect = provider.open(Sect.fromAddress(sectAddress));

    const clanId = await sect.getClanId();
    console.log('clanId', clanId);
    const getTotalKey = await sect.getTotalKey();
    console.log('getTotalKey', getTotalKey)
    const getGetAmountKey = await sect.getGetAmountKey(1712265907n);
    console.log('getGetAmountKey', getGetAmountKey)
    const buyPrice = await sect.getBuyPrice();
    console.log('buyPrice', buyPrice)
   
    ui.clearActionPrompt();
}
