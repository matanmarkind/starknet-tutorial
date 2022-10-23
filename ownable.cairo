# Contract address: 0x044598f194060ff671bdd3931924dedc9a98dc618ccdee96037e2aac956b368f
# Transaction hash: 0x664337796af55f9d7841764f7ca317ee196a95a1a57f751847a754e10510205

%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

# Define a storage variable for the owner address.
@storage_var
func owner() -> (owner_address : felt):
end

@constructor
func constructor{
    syscall_ptr : felt*,
    pedersen_ptr : HashBuiltin*,
    range_check_ptr,
}(owner_address : felt):
    owner.write(value=owner_address)
    return ()
end