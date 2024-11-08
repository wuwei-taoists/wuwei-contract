import { Address, toNano } from '@ton/core';
import { Taoists } from '../wrappers/Taoists';
import { NetworkProvider, sleep } from '@ton/blueprint';

export async function run(provider: NetworkProvider, args: string[]) {
    const ui = provider.ui();

    const address = Address.parse(args.length > 0 ? args[0] : await ui.input('Taoists address'));

    if (!(await provider.isContractDeployed(address))) {
        ui.write(`Error: Contract at address ${address} is not deployed!`);
        return;
    }

    const taoists = provider.open(Taoists.fromAddress(address));

    console.log('Create Sect')
    await taoists.send(
        provider.sender(),
        {
            value: toNano('0.1'),
        },
        {
            $$type: 'CreateSect',
            clanId: 1n,
            teleId: 123456n,
        }
    );

    ui.write('Waiting Create Sect...');

    let sectAddress = await taoists.getClanAddress(1n);

    await provider.waitForDeploy(sectAddress);
    ui.clearActionPrompt();
}
