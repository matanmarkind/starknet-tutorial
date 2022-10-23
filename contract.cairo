# starknet deploy --contract ./artifacts/contract_compiled.json --account=matan2
# Deploy transaction was sent.
# Contract address: 0x053ed1e72a60fec88754b1665a3a51f2918cd7ebe40fba9b9286332f47352bbf
# Transaction hash: 0x34342a73cb826b1c0d300a444a92717ebc485b0da4ca70238a40e86176a1802

# Declare this file as a StarkNet contract.
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

# Define a storage variable.
@storage_var
func balance() -> (res : felt):
end

# Increases the balance by the given amount.
@external
func increase_balance{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(amount : felt):
    let (res) = balance.read()
    balance.write(res + amount)
    return ()
end

# Returns the current balance.
@view
func get_balance{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}() -> (res : felt):
    let (res) = balance.read()
    return (res)
end
