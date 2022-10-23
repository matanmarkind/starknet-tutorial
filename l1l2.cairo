# starknet deploy --contract ./artifacts/l1l2_compiled.json --account matan2
# Deploy transaction was sent.
# Contract address: 0x04c3a08d7d11132a2481c9b6a86f18c2faffc99527867eb10acf24da6626a199
# Transaction hash: 0x70e3d36cb19752591338ee4f6ff89bbc759208d32092c98cfc2f5a68dd4f880

%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.math import assert_nn
from starkware.starknet.common.messages import send_message_to_l1

# Identify the L1 contract to interact with.
const L1_CONTRACT_ADDRESS = (
    0x2Db8c2615db39a5eD8750B87aC8F217485BE11EC)
# Identify which function on the L1 contract to interact with.
const MESSAGE_WITHDRAW = 0

# A mapping from a user (L1 Ethereum address) to their balance.
@storage_var
func balance(user : felt) -> (res : felt):
end

@view
func get_balance{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(user : felt) -> (balance : felt):
    let (res) = balance.read(user=user)
    return (res)
end

@external
func increase_balance{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(user : felt, amount : felt):
    let (res) = balance.read(user=user)
    balance.write(user, res + amount)
    return ()
end

@external
func withdraw{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(user : felt, amount : felt):
    assert_nn(amount)

    let (res) = balance.read(user=user)
    let new_balance = res - amount
    assert_nn(new_balance)
    balance.write(user, new_balance)

    let (payload : felt*) = alloc()
    assert payload[0] = MESSAGE_WITHDRAW
    assert payload[1] = user
    assert payload[2] = amount

    send_message_to_l1(
        to_address=L1_CONTRACT_ADDRESS,
        payload_size=3,
        payload=payload,
    )

    return ()
end

@l1_handler
func deposit{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(from_address : felt, user : felt, amount : felt):
    assert from_address = L1_CONTRACT_ADDRESS
    
    let (res) = balance.read(user=user)
    tempvar new_balance = res + amount
    balance.write(user, new_balance)

    return ()
end