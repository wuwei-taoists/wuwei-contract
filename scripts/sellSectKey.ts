import { Address, toNano } from '@ton/core';
import { Taoists } from '../wrappers/Taoists';
import { NetworkProvider, sleep } from '@ton/blueprint';
import { Sect } from '../build/Taoists/tact_Sect';

export async function run(provider: NetworkProvider, args: string[]) {
    const ui = provider.ui();

    const address = Address.parse(args.length > 0 ? args[0] : await ui.input('Sect address'));

    if (!(await provider.isContractDeployed(address))) {
        ui.write(`Error: Contract at address ${address} is not deployed!`);
        return;
    }

    const sect = provider.open(Sect.fromAddress(address));

    const clanId = await sect.getClanId();
    console.log('clanId', clanId);
    const getGetAmountKey = await sect.getGetAmountKey(12345n);
    console.log('getGetAmountKey', getGetAmountKey)

    await sect.send(
        provider.sender(),
        {
            value: toNano('0.15'),
        },
        {
            $$type: 'Action',
            teleId: 12345n,
            actionId: 2n,
        }
    );

    let newAmountKey = getGetAmountKey;
    while (newAmountKey == getGetAmountKey) {
        ui.write('Waiting Sell Key...');
        newAmountKey = await sect.getGetAmountKey(12345n);
        await sleep(2000)
    }
    console.log('newAmountKey', newAmountKey)
    ui.write('Waiting Create Sect...');
    ui.clearActionPrompt();
}
