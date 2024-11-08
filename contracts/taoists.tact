import "@stdlib/deploy";
import "./sect.tact";

message CreateSect {
    clanId: Int;
    teleId: Int;
}

message Withdraw {
    out: Address;
}

contract Taoists with Deployable {
    owner: Address;

    init(owner: Address) {
        self.owner = owner;
    }

    receive(msg: CreateSect) {
        let init: StateInit = initOf Sect(msg.clanId, myAddress());
        let address: Address = contractAddress(init);
        send(SendParameters{
            to: address,
            value: ton("0.05"),
            mode: SendIgnoreErrors,
            code: init.code,
            data: init.data,
            body: CreateSectMsg{ teleId: msg.teleId, sender: sender() }.toCell()
        });
        self.reply("refund gas".asComment());
    }

    receive(msg: Withdraw) {
        require(sender() == self.owner, "Not the contract owner!");
        send(SendParameters{
            to: msg.out,
            value: 0,
            mode: SendRemainingBalance | SendIgnoreErrors,
        });
    }

    receive(str: String) { // refund gas
        // send(SendParameters{
        //     to: sender(),
        //     value: 0,
        //     mode: SendRemainingValue | SendIgnoreErrors,
        // });
    }

    get fun clanAddress(clanId: Int): Address {
        let init: StateInit = initOf Sect(clanId, myAddress());
        return contractAddress(init);
    }
}
