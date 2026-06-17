#!/bin/bash
set -e

FIRESTORE_HOST="http://localhost:8080"
AUTH_HOST="http://localhost:9099"
PROJECT="demo-project"

echo "[seed] Clearing existing Firestore data..."
curl -s -X DELETE "${FIRESTORE_HOST}/emulator/v1/projects/${PROJECT}/databases/(default)/documents" > /dev/null

echo "[seed] Seeding Auth users..."

create_user() {
  local EMAIL=$1
  local PASSWORD=$2
  local USER_ID=$3
  curl -s -X POST \
    "${AUTH_HOST}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=demo-key" \
    -H "Content-Type: application/json" \
    -d "{\"email\":\"${EMAIL}\",\"password\":\"${PASSWORD}\",\"localId\":\"${USER_ID}\"}" > /dev/null
}

create_user "alice@example.com" "password123" "uid-alice"
create_user "bob@example.com" "password123" "uid-bob"
create_user "carol@example.com" "password123" "uid-carol"
create_user "david@example.com" "password123" "uid-david"
create_user "eve@example.com" "password123" "uid-eve"
create_user "frank@example.com" "password123" "uid-frank"
create_user "grace@example.com" "password123" "uid-grace"
create_user "henry@example.com" "password123" "uid-henry"
create_user "isla@example.com" "password123" "uid-isla"
create_user "jack@example.com" "password123" "uid-jack"

echo "[seed] Seeding Firestore users collection..."

write_doc() {
  local DOC_PATH=$1
  local DATA=$2
  curl -s -X PATCH \
    "${FIRESTORE_HOST}/v1/projects/${PROJECT}/databases/(default)/documents/${DOC_PATH}" \
    -H "Content-Type: application/json" \
    -d "${DATA}" > /dev/null
}

write_doc "users/uid-alice" '{"fields":{"displayName":{"stringValue":"Alice"},"email":{"stringValue":"alice@example.com"},"householdId":{"stringValue":"household-alpha"}}}'
write_doc "users/uid-bob" '{"fields":{"displayName":{"stringValue":"Bob"},"email":{"stringValue":"bob@example.com"},"householdId":{"stringValue":"household-alpha"}}}'
write_doc "users/uid-carol" '{"fields":{"displayName":{"stringValue":"Carol"},"email":{"stringValue":"carol@example.com"},"householdId":{"stringValue":"household-beta"}}}'
write_doc "users/uid-david" '{"fields":{"displayName":{"stringValue":"David"},"email":{"stringValue":"david@example.com"},"householdId":{"stringValue":"household-beta"}}}'
write_doc "users/uid-eve" '{"fields":{"displayName":{"stringValue":"Eve"},"email":{"stringValue":"eve@example.com"},"householdId":{"stringValue":"household-gamma"}}}'
write_doc "users/uid-frank" '{"fields":{"displayName":{"stringValue":"Frank"},"email":{"stringValue":"frank@example.com"},"householdId":{"stringValue":"household-gamma"}}}'
write_doc "users/uid-grace" '{"fields":{"displayName":{"stringValue":"Grace"},"email":{"stringValue":"grace@example.com"},"householdId":{"stringValue":"household-delta"}}}'
write_doc "users/uid-henry" '{"fields":{"displayName":{"stringValue":"Henry"},"email":{"stringValue":"henry@example.com"},"householdId":{"stringValue":"household-delta"}}}'
write_doc "users/uid-isla" '{"fields":{"displayName":{"stringValue":"Isla"},"email":{"stringValue":"isla@example.com"},"householdId":{"stringValue":"household-epsilon"}}}'
write_doc "users/uid-jack" '{"fields":{"displayName":{"stringValue":"Jack"},"email":{"stringValue":"jack@example.com"},"householdId":{"stringValue":"household-epsilon"}}}'

echo "[seed] Seeding households collection..."

write_doc "households/household-alpha" '{"fields":{"name":{"stringValue":"The Alpha House"},"createdBy":{"stringValue":"uid-alice"},"expenseCount":{"integerValue":"0"},"memberIds":{"arrayValue":{"values":[{"stringValue":"uid-alice"},{"stringValue":"uid-bob"}]}}}}'
write_doc "households/household-beta" '{"fields":{"name":{"stringValue":"Beta Apartments"},"createdBy":{"stringValue":"uid-carol"},"expenseCount":{"integerValue":"0"},"memberIds":{"arrayValue":{"values":[{"stringValue":"uid-carol"},{"stringValue":"uid-david"}]}}}}'
write_doc "households/household-gamma" '{"fields":{"name":{"stringValue":"Gamma Residency"},"createdBy":{"stringValue":"uid-eve"},"expenseCount":{"integerValue":"0"},"memberIds":{"arrayValue":{"values":[{"stringValue":"uid-eve"},{"stringValue":"uid-frank"}]}}}}'
write_doc "households/household-delta" '{"fields":{"name":{"stringValue":"Delta Lofts"},"createdBy":{"stringValue":"uid-grace"},"expenseCount":{"integerValue":"0"},"memberIds":{"arrayValue":{"values":[{"stringValue":"uid-grace"},{"stringValue":"uid-henry"}]}}}}'
write_doc "households/household-epsilon" '{"fields":{"name":{"stringValue":"Epsilon Terrace"},"createdBy":{"stringValue":"uid-isla"},"expenseCount":{"integerValue":"0"},"memberIds":{"arrayValue":{"values":[{"stringValue":"uid-isla"},{"stringValue":"uid-jack"}]}}}}'

echo "[seed] Seeding expenses subcollections..."

write_doc "households/household-alpha/expenses/exp-a1" '{"fields":{"description":{"stringValue":"Weekly groceries"},"amount":{"doubleValue":87.50},"paidBy":{"stringValue":"uid-alice"},"category":{"stringValue":"Food"},"settled":{"booleanValue":false},"createdAt":{"timestampValue":"2024-06-01T10:00:00Z"}}}'
write_doc "households/household-alpha/expenses/exp-a2" '{"fields":{"description":{"stringValue":"Electricity bill"},"amount":{"doubleValue":120.00},"paidBy":{"stringValue":"uid-bob"},"category":{"stringValue":"Utilities"},"settled":{"booleanValue":false},"createdAt":{"timestampValue":"2024-06-02T14:00:00Z"}}}'
write_doc "households/household-alpha/expenses/exp-a3" '{"fields":{"description":{"stringValue":"Netflix subscription"},"amount":{"doubleValue":15.99},"paidBy":{"stringValue":"uid-alice"},"category":{"stringValue":"Entertainment"},"settled":{"booleanValue":true},"createdAt":{"timestampValue":"2024-05-30T09:00:00Z"}}}'

write_doc "households/household-beta/expenses/exp-b1" '{"fields":{"description":{"stringValue":"Internet bill"},"amount":{"doubleValue":60.00},"paidBy":{"stringValue":"uid-carol"},"category":{"stringValue":"Utilities"},"settled":{"booleanValue":false},"createdAt":{"timestampValue":"2024-06-01T08:00:00Z"}}}'
write_doc "households/household-beta/expenses/exp-b2" '{"fields":{"description":{"stringValue":"House cleaning supplies"},"amount":{"doubleValue":34.20},"paidBy":{"stringValue":"uid-david"},"category":{"stringValue":"Household"},"settled":{"booleanValue":false},"createdAt":{"timestampValue":"2024-06-03T11:00:00Z"}}}'

write_doc "households/household-gamma/expenses/exp-g1" '{"fields":{"description":{"stringValue":"Dinner out"},"amount":{"doubleValue":95.00},"paidBy":{"stringValue":"uid-eve"},"category":{"stringValue":"Food"},"settled":{"booleanValue":false},"createdAt":{"timestampValue":"2024-06-04T19:00:00Z"}}}'

write_doc "households/household-delta/expenses/exp-d1" '{"fields":{"description":{"stringValue":"Parking permit"},"amount":{"doubleValue":45.00},"paidBy":{"stringValue":"uid-grace"},"category":{"stringValue":"Transport"},"settled":{"booleanValue":false},"createdAt":{"timestampValue":"2024-06-02T10:00:00Z"}}}'

write_doc "households/household-epsilon/expenses/exp-e1" '{"fields":{"description":{"stringValue":"Water bill"},"amount":{"doubleValue":55.75},"paidBy":{"stringValue":"uid-isla"},"category":{"stringValue":"Utilities"},"settled":{"booleanValue":false},"createdAt":{"timestampValue":"2024-06-01T12:00:00Z"}}}'

echo "[seed] All seed data loaded successfully."
echo "[seed] Test credentials: alice@example.com / password123"
echo "[seed] Test credentials: carol@example.com / password123"
