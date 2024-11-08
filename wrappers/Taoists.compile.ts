import { CompilerConfig } from '@ton/blueprint';

export const compile: CompilerConfig = {
    lang: 'tact',
    target: 'contracts/taoists.tact',
    options: {
        debug: true,
    },
};
