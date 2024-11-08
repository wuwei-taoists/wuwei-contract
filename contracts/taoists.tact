import "@stdlib/deploy";
import "./sect.tact";

message CreateSect {
    clanId: Int;
    teleId: Int;
}

contract Taoists with Deployable {

    receive(msg: CreateSect) {
        let init: StateInit = initOf Sect(msg.clanId, myAddress());
        let address: Address = contractAddress(init);
        let mess: StringBuilder = beginString();
        mess.append("CreateSect|");
        mess.append(msg.teleId.toString());
        send(SendParameters{
            to: address,
            value: ton("0.05"),
            mode: SendIgnoreErrors,
            code: init.code,
            data: init.data,
            body: mess.toString().asComment()
        });
    }

    receive(str: String) {}

    get fun clanAddress(clanId: Int): Address {
        let init: StateInit = initOf Sect(clanId, myAddress());
        return contractAddress(init);
    }
}
