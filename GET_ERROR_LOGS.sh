#!/bin/bash
# Get error logs from Flutter app

echo "Watching for payment and booking errors..."
echo "Try purchasing a ticket now, then check output below:"
echo ""

flutter logs 2>&1 | grep -E "(TICKET|💳|📝|✅|❌|ERROR|Exception)"
