import "@stdlib/deploy";

message CreateSectMsg {
    teleId: Int;
    sender: Address;
}

message BuyKey {
    teleId: Int;
}

message SellKey {
    teleId: Int;
}

contract Sect with Deployable {
    clanId: Int;
    totalKey: Int;
    member: map<Int, Int>;
    nextPrice: Int as coins;
    masterAddress: Address;

    init(clanId: Int, masterAddress: Address) {
        self.clanId = clanId;
        self.totalKey = 0;
        self.member = emptyMap();
        self.nextPrice = 100000000;
        self.masterAddress = masterAddress;
    }

    receive(msg: CreateSectMsg) {
        let mess: StringBuilder = beginString();
        mess.append("CreateSect|");
        mess.append(msg.teleId.toString());
        send(SendParameters{
            to: self.masterAddress,
            value: 0,
            mode: SendRemainingValue + SendIgnoreErrors,
            body: mess.toString().asComment()
        });
    }

    receive(msg: BuyKey) {
        require(context().value > self.nextPrice, "TON is not enough");
        let amount = self.nextPrice;
        let currentKey: Int? = self.member.get(msg.teleId);
        if (currentKey == null) {
            currentKey = 0;
        }
        self.member.set(msg.teleId, currentKey!! + 1);
        self.totalKey = self.totalKey + 1;
        self.nextPrice = self.nextPrice * 110 / 100;

        let mess: StringBuilder = beginString();
        mess.append("Buy|");
        mess.append(msg.teleId.toString());

        send(SendParameters{
            to: self.masterAddress,
            value: ton("0.02"),
            mode: SendPayGasSeparately + SendIgnoreErrors,
            body: mess.toString().asComment()
        });
    }

    receive(msg: SellKey) {
        let currentKey: Int? = self.member.get(msg.teleId);
        require(currentKey != null, "Key not found");
        self.member.set(msg.teleId, currentKey!! - 1);
        let amount = self.nextPrice * 90 / 100 * 90 / 100;

        send(SendParameters{
            to: sender(),
            bounce: false,
            value: amount,
            mode: SendIgnoreErrors
        });

        self.totalKey = self.totalKey - 1;
        self.nextPrice = self.nextPrice * 90 / 100;

        let mess: StringBuilder = beginString();
        mess.append("Sell|");
        mess.append(msg.teleId.toString());

        send(SendParameters{
            to: self.masterAddress,
            value: ton("0.02"),
            mode: SendPayGasSeparately + SendIgnoreErrors,
            body: mess.toString().asComment()
        });

        send(SendParameters{
            to: sender(),
            value: 0,
            mode: SendRemainingValue + SendIgnoreErrors,
        });
    }
    

    get fun getAmountKey(teleId: Int): Int {
        return self.member.get(teleId) == null ? 0 : self.member.get(teleId)!!;
    }

    get fun buyPrice(): Int {
        return self.nextPrice;
    }

    get fun sellPrice(): Int {
        return self.nextPrice * 80 / 100;
    }

    get fun totalKey(): Int {
        return self.totalKey;
    }

    get fun clanId(): Int {
        return self.clanId;
    }

    get fun masterAddress(): Address {
        return self.masterAddress;
    }
}