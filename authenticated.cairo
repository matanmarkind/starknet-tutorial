# Contract address: 0x05bcec3a11133dda2e0c54f3f9442507d494d8820b5360d015b70f35470dcefa

# Declare this file as a StarkNet contract.
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.starknet.common.syscalls import get_caller_address
from starkware.cairo.common.math import assert_nn

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