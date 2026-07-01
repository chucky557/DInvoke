# Port of Injection/Payload.cs
# Base classes and types for payload representation.
# Defines the type hierarchy for all injectable payloads.

# C# original: using DynamicInvoke = DInvoke.DynamicInvoke;
# Nim: Import modules as needed

# C# original: namespace DInvoke.Injection
# Nim translation: Module-level types for payload classes and exceptions

## Base class for all types of payloads.
## Variants are responsible for specifying what types of payloads they support.
## Author: The Wover (@TheRealWover)
## 
## C# original: public abstract class PayloadType
##   The C# version uses a property with private setter.
##   Nim translation: Using object with field, enforce immutability through documentation.
type PayloadType* = object of RootObj
  ## The actual payload bytes
  payload*: seq[uint8]

## Constructor-like initializer for PayloadType
## Author: The Wover (@TheRealWover)
## Params: data - The payload as a byte sequence
proc newPayloadType*(data: seq[uint8]): PayloadType =
  PayloadType(payload: data)

## Represents payloads that are position-independent-code (PIC).
## These payloads can be executed from any address in memory.
## Author: The Wover (@TheRealWover)
##
## C# original: public class PICPayload : PayloadType
##   Inherits from PayloadType and uses base constructor.
type PICPayload* = object of PayloadType
  # No additional fields; inherits payload from PayloadType

## Constructor-like initializer for PICPayload
## Params: data - The PIC payload as a byte sequence
proc newPICPayload*(data: seq[uint8]): PICPayload =
  PICPayload(payload: data)

## Exception thrown when the type of a payload is not supported by an injection variant.
## Author: The Wover (@TheRealWover)
##
## C# original: public class PayloadTypeNotSupported : Exception
##   Inherits from Exception; can be created with or without payload type info.
type PayloadTypeNotSupported* = object of CatchableError
  payloadType*: string

## Create a PayloadTypeNotSupported exception with no arguments.
## C# original: public PayloadTypeNotSupported() { }
proc newPayloadTypeNotSupported*(): PayloadTypeNotSupported =
  PayloadTypeNotSupported(msg: "Unsupported Payload type")

## Create a PayloadTypeNotSupported exception with payload type information.
## C# original: public PayloadTypeNotSupported(Type payloadType) : base(...)
## Params: payloadType - String name of the unsupported payload type
proc newPayloadTypeNotSupported*(payloadType: string): PayloadTypeNotSupported =
  let msg = "Unsupported Payload type: " & payloadType
  PayloadTypeNotSupported(msg: msg, payloadType: payloadType)
