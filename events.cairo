# starknet deploy --contract ./artifacts/events_compiled.json --account matan2
# Deploy transaction was sent.
# Contract address: 0x0428123a6d6bab7f30a18ce7ae3ffd2144fad2046cf8f03cd6d8404498a028a7
# Transaction hash: 0x48b1c39ceecc77831f393c6a4238ffe53c9e6b43b917e850311ba94928320f1

# Declare this file as a StarkNet contract.
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_nn

# An event emitted whenever increase_balance() is called.
# current_balance is the balance before it was increased.
@event
func increase_balance_called(
    current_balance : felt, amount : felt
):
end

# Define a storage variable.
@storage_var
func balance(user : felt) -> (res : felt):
end

# Increases the balance by the given amount.
@external
func increase_balance{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(amount : felt):
    with_attr error_message("Amount must be positive. Got: {amount}."):
        assert_nn(amount)
    end

    let (user) = get_caller_address()
    let (res) = balance.read(user)
    balance.write(user, res + amount)

    # Emit the event.
    increase_balance_called.emit(current_balance=res, amount=amount)
    return ()
end

# Returns the current balance.
@view
func get_balance{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}() -> (res : felt):
    let (user) = get_caller_address()
    let (res) = balance.read(user=user)
    return (res)
end