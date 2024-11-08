import { toNano } from '@ton/core';
import { Taoists } from '../wrappers/Taoists';
import { NetworkProvider } from '@ton/blueprint';

export async function run(provider: NetworkProvider) {
    const taoists = provider.open(await Taoists.fromInit());

    await taoists.send(
        provider.sender(),
        {
            value: toNano('0.05'),
        },
        {
            $$type: 'Deploy',
            queryId: 0n,
        }
    );

    await provider.waitForDeploy(taoists.address);

    // console.log('ID', await taoists.getId());
}
